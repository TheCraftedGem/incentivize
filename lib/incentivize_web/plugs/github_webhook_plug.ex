defmodule IncentivizeWeb.GhWebhookPlug do
  import Plug.Conn
  require Logger
  alias Incentivize.Repositories

  def init(options) do
    options
  end

  @doc """
  Verifies secret and calls a handler with the webhook payload
  """
  def call(conn, _options) do
    payload = conn.assigns[:raw_body]
    parsed_body = conn.body_params

    repository =
      Repositories.get_repository_by_owner_and_name(
        parsed_body["repository"]["owner"]["login"],
        parsed_body["repository"]["name"]
      )

    case repository do
      nil ->
        conn
        |> send_resp(403, "Forbidden")
        |> halt()

      repository ->
        secret = repository.webhook_secret

        [signature_in_header] = get_req_header(conn, "x-hub-signature")

        if verify_signature(payload, secret, signature_in_header) do
          conn
        else
          conn
          |> send_resp(403, "Forbidden")
          |> halt()
        end
    end
  end

  defp verify_signature(payload, secret, signature_in_header) do
    signature = "sha1=" <> (:crypto.hmac(:sha, secret, payload) |> Base.encode16(case: :lower))
    Plug.Crypto.secure_compare(signature, signature_in_header)
  end
end
