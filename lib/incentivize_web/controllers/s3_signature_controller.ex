defmodule IncentivizeWeb.S3SignatureController do
  use IncentivizeWeb, :controller
  alias Ecto.UUID
  alias ExAws.{Config, S3}

  def sign(conn, %{"file_name" => original_file_name}) do
    uri = URI.parse(original_file_name)

    uuid = UUID.generate()

    extension =
      uri.path
      |> Path.extname()
      |> String.downcase()

    basename =
      uri.path
      |> Path.basename(extension)
      |> String.downcase()

    new_file_name = "#{basename}-#{uuid}#{extension}"
    result = get_signed_url(new_file_name)

    case result do
      {:ok, signed_url} ->
        bucket = Application.get_env(:incentivize, :s3_bucket)

        response = %{
          data: %{
            signed_request: signed_url,
            file_name: new_file_name,
            file_type: MIME.type(String.replace_leading(extension, ".", "")),
            url: "https://s3.amazonaws.com/#{bucket}/uploads/#{new_file_name}"
          }
        }

        json(conn, response)

      _ ->
        error = %{
          errors: %{
            "all" => ["Unauthorized"]
          }
        }

        conn
        |> put_status(400)
        |> json(error)
    end
  end

  def sign(conn, _params) do
    error = %{
      errors: %{
        "all" => ["Invalid request"]
      }
    }

    conn
    |> put_status(400)
    |> json(error)
  end

  defp get_signed_url(new_file_name) do
    bucket = Confex.get_env(:incentivize, :s3_bucket)
    s3_config = Config.new(:s3)

    S3.presigned_url(s3_config, :put, bucket, "uploads/" <> new_file_name)
  end
end
