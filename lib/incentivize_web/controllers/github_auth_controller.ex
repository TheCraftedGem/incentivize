defmodule IncentivizeWeb.GithubAuthController do
  use IncentivizeWeb, :controller
  alias Incentivize.Github.OAuth, as: GitHub
  alias Incentivize.Users

  def index(conn, _params) do
    redirect(conn, external: GitHub.authorize_url!())
  end

  def callback(conn, %{
        "error" => _error,
        "error_description" => _error_description,
        "error_uri" => _error_uri
      }) do
    conn
    |> put_flash(:error, "Unable to login")
    |> redirect(to: "/")
  end

  def callback(conn, %{"code" => code}) do
    # Exchange an auth code for an access token
    client = GitHub.get_token!(code: code)

    # Request the user's data with the access token
    %{body: user} = OAuth2.Client.get!(client, "/user")
    params = %{
      github_login: user["login"],
      github_avatar_url: user["avatar_url"],
      github_access_token: client.token.access_token,
      logged_in_at: DateTime.utc_now()
    }

    case Users.create_or_update_user_by_github_login(user["login"], params) do
      {:ok, user} ->
        url =
          case user.stellar_public_key do
            nil ->
              account_path(conn, :edit)

            _ ->
              account_path(conn, :show)
          end

        conn =
          conn
          |> assign(:current_user, user)
          |> put_session(:user_id, user.id)
          |> configure_session(renew: true)

        conn
        |> put_flash(:info, "Welcome #{user.github_login}")
        |> redirect(to: url)

      {:error, _changeset} ->
        conn
        |> put_flash(:info, "Unable to login")
        |> redirect(to: "/")
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
