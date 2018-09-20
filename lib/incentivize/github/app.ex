defmodule Incentivize.Github.App do
  @moduledoc """
  Functions for interacting with GitHub App Api
  """
  alias Incentivize.Github.API.Base

  @doc """
  The public URL of the GitHub App.
  """
  def public_url do
    app_slug = Confex.get_env(:incentivize, Incentivize.Github.App)[:app_slug]
    "https://github.com/apps/#{app_slug}"
  end

  @doc """
  Gets all installations associated with the app
  """
  def get_app_installations do
    "#{Base.base_url()}/app/installations"
    |> HTTPoison.get(headers())
    |> Base.process_response()
  end

  def get_app_installation(installation_id) do
    "#{Base.base_url()}/app/installations/#{installation_id}"
    |> HTTPoison.get(headers())
    |> Base.process_response()
  end

  @doc """
  Gets the user's app installation information using their
  username
  """
  def get_user_app_installation_by_github_login(github_login) do
    "#{Base.base_url()}/users/#{github_login}/installation"
    |> HTTPoison.get(headers())
    |> Base.process_response()
  end

  @doc """
  Gets the organizations's app installation information using their
  name
  """
  def get_organization_app_installation_by_github_login(github_login) do
    "#{Base.base_url()}/orgs/#{github_login}/installation"
    |> HTTPoison.get(headers())
    |> Base.process_response()
  end

  @doc """
  Gets repositories for the given installation
  """
  def get_app_installation_repositories(installation_id) do
    {:ok, %{"token" => token}} = get_installation_access_token(installation_id)

    header = headers(token)

    "#{Base.base_url()}/installation/repositories"
    |> HTTPoison.get(header)
    |> Base.process_response(header)
  end

  @doc """
  Gets an installation app token. Used to make GitHub API requests as the installation
  """
  def get_installation_access_token(installation_id) do
    "#{Base.base_url()}/installations/#{installation_id}/access_tokens"
    |> HTTPoison.post("", headers())
    |> Base.process_response()
  end

  defp headers do
    [
      {"User-Agent", "Incentivize"},
      {"Accept", "application/vnd.github.machine-man-preview+json"},
      {"Authorization", "Bearer #{get_app_auth_token()}"}
    ]
  end

  defp headers(installation_access_token) do
    [
      {"User-Agent", "Incentivize"},
      {"Accept", "application/vnd.github.machine-man-preview+json"},
      {"Authorization", "Bearer #{installation_access_token}"}
    ]
  end

  # Generates token for github app-level API calls
  defp get_app_auth_token do
    import Joken
    alias JOSE.JWK

    config = Confex.get_env(:incentivize, Incentivize.Github.App)

    key = JWK.from_pem(config[:private_key])

    %{
      "iss" => config[:app_id],
      "iat" => DateTime.to_unix(DateTime.utc_now()),
      "exp" => DateTime.to_unix(DateTime.utc_now()) + 10 * 60
    }
    |> token
    |> sign(rs256(key))
    |> get_compact
  end
end
