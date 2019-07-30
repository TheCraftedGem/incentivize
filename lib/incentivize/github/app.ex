defmodule Incentivize.Github.App do
  @moduledoc """
  Functions for interacting with GitHub App Api
  """
  alias Incentivize.Github.API.Base

  @doc """
  Gets either this module or one that is defined at :github_app_module
  """
  def github_app_module do
    Application.get_env(
      :incentivize,
      :github_app_module,
      __MODULE__
    )
  end

  @doc """
  The public URL of the GitHub App.
  """
  def public_url do
    app_slug = Confex.get_env(:incentivize, Incentivize.Github.App)[:app_slug]
    "https://github.com/apps/#{app_slug}"
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
  Gets an installation app token. Used to make GitHub API requests as the installation
  """
  def get_installation_access_token(installation_id) do
    "#{Base.base_url()}/app/installations/#{installation_id}/access_tokens"
    |> HTTPoison.post("", headers())
    |> Base.process_response()
  end

  defp headers do
    headers(get_app_auth_token())
  end

  defp headers(access_token) do
    [
      {"User-Agent", "Incentivize"},
      {"Accept", "application/vnd.github.machine-man-preview+json"},
      {"Authorization", "Bearer #{access_token}"}
    ]
  end

  # Generates token for github app-level API calls
  defp get_app_auth_token do
    config = Confex.get_env(:incentivize, Incentivize.Github.App, [])
    private_key = config[:private_key]

    if private_key do
      import Joken
      alias JOSE.JWK

      private_key = JWK.from(private_key)

      %{
        "iss" => config[:app_id],
        "iat" => DateTime.to_unix(DateTime.utc_now()),
        "exp" => DateTime.to_unix(DateTime.utc_now()) + 10 * 60
      }
      |> token
      |> sign(rs256(private_key))
      |> get_compact
    else
      ""
    end
  end

  @spec list_organizations_for_user(User.t()) :: {:ok, map} | {:error, binary}
  def list_organizations_for_user(user) do
    url =
      "#{Base.base_url()}/user/memberships/orgs?access_token=#{user.github_access_token}&state=active"

    url
    |> HTTPoison.get(Base.headers())
    |> Base.process_response()
  end

  @spec get_user(User.t()) :: {:ok, map} | {:error, binary}
  def get_user(user) do
    url = "#{Base.base_url()}/user?access_token=#{user.github_access_token}"

    url
    |> HTTPoison.get(Base.headers())
    |> Base.process_response()
  end

  @spec list_user_repos(User.t()) :: {:ok, map} | {:error, binary}
  def list_user_repos(user) do
    url = "#{Base.base_url()}/user/repos?access_token=#{user.github_access_token}"

    url
    |> HTTPoison.get(Base.headers())
    |> Base.process_response()
  end
end
