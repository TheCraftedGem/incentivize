defmodule IncentivizeWeb.GithubAuthController.Test do
    @moduledoc false
  use IncentivizeWeb.ConnCase

  test "GET /auth/github", %{conn: conn} do
    conn = get(conn, github_auth_path(conn, :index))
    assert redirected_to(conn)
  end

  test "GET /auth/delete when logged out", %{conn: conn} do
    conn = get(conn, github_auth_path(conn, :delete))
    assert response(conn, 403) =~ "Unauthorized"
  end

  test "GET /session/delete when logged in", %{conn: conn} do
    user = insert!(:user)

    conn =
      conn
      |> assign(:current_user, user)

    conn = get(conn, github_auth_path(conn, :delete))
    assert redirected_to(conn) =~ page_path(conn, :index)
  end
end
