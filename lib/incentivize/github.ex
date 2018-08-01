defmodule Incentivize.Github do
  @doc """
  Generates token for github app-level API calls
  """
  def get_app_auth_token() do
    config = Application.get_env(:incentivize, __MODULE__)

    import Joken
    key = JOSE.JWK.from_pem_file(config[:private_key_path])

    %{
      "iss" => config[:app_id],
      "iat" => DateTime.to_unix(DateTime.utc_now()),
      "exp" => DateTime.to_unix(DateTime.utc_now()) + (10 * 60)
    }
    |> token
    |> sign(rs256(key))
    |> get_compact
  end

  @doc """
  Gets all installations associated with the app
  """
  def get_app_installations() do
    HTTPoison.get("https://api.github.com/app/installations", [
      {"Accept", "application/vnd.github.machine-man-preview+json"},
      {"Authorization", "Bearer #{get_app_auth_token()}"}
    ])
  end

  @doc """
  Gets an installation app token. Used to make GitHub API requests as the installation
  """
  def get_installation_access_token(installation_id) do
    HTTPoison.post("https://api.github.com/installations/#{installation_id}/access_tokens", "", [
      {"Accept", "application/vnd.github.machine-man-preview+json"},
      {"Authorization", "Bearer #{get_app_auth_token()}"}
    ])
  end
end
