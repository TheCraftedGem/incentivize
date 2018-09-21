defmodule IncentivizeWeb.RepositoryControllerTest do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true

  setup %{conn: conn} do
    user = insert!(:user)

    conn =
      conn
      |> assign(:current_user, user)

    [user: user, conn: conn]
  end

  test "GET /repos/settings", %{conn: conn} do
    conn = get(conn, repository_path(conn, :new))
    assert html_response(conn, 200) =~ "Connect Repositories"
    assert html_response(conn, 200) =~ "Install"
  end

  test "GET /repos", %{conn: conn} do
    insert!(:repository, owner: "octocat", name: "Hello-World5")

    conn = get(conn, repository_path(conn, :index))
    assert html_response(conn, 200) =~ "Discover"
  end

  test "GET /repos/:owner/:name", %{conn: conn} do
    insert!(:repository, owner: "octocat", name: "Hello-World5")

    conn = get(conn, repository_path(conn, :show, "octocat", "Hello-World5"))
    assert html_response(conn, 200) =~ "octocat/Hello-World"
  end

  test "GET /repos/:owner/:name when not found", %{conn: conn} do
    conn = get(conn, repository_path(conn, :show, "octocat", "Hello-World5"))
    assert html_response(conn, 404)
  end
end
