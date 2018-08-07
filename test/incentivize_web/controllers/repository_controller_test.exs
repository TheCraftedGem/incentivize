defmodule IncentivizeWeb.RepositoryControllerTest do
  use IncentivizeWeb.ConnCase
  alias Incentivize.Repositories

  setup %{conn: conn} do
    user = insert!(:user)

    conn =
      conn
      |> assign(:current_user, user)

    [user: user, conn: conn]
  end

  test "GET /repos/new", %{conn: conn} do
    conn = get(conn, repository_path(conn, :new))
    assert html_response(conn, 200) =~ "Connect To Repository"
    assert html_response(conn, 200) =~ "Owner"
    assert html_response(conn, 200) =~ "Repository Name"
  end

  test "POST /repos/create", %{conn: conn, user: _user} do
    conn = post(conn, repository_path(conn, :create), repository: [owner: "me", name: "me"])
    assert redirected_to(conn) =~ repository_path(conn, :webhook, "me", "me")

    assert Repositories.get_repository_by_owner_and_name("me", "me") != nil
  end

  test "POST /repos/create with bad data", %{conn: conn} do
    conn = post(conn, repository_path(conn, :create), repository: [owner: "", name: "me"])
    assert html_response(conn, 400) =~ "Owner"

    assert Repositories.get_repository_by_owner_and_name("me", "me") == nil
  end

  test "GET /repos/:owner/:name/webhook when not authorized", %{conn: conn, user: _user} do
    insert!(:repository, owner: "me", name: "me")

    conn = get(conn, repository_path(conn, :webhook, "me", "me"))
    assert response(conn, 403) =~ "Unauthorized"
  end

  test "GET /repos/:owner/:name/webhook when authorized", %{conn: conn, user: user} do
    insert!(:repository, owner: "me", name: "me", admin: user)

    conn = get(conn, repository_path(conn, :webhook, "me", "me"))
    assert html_response(conn, 200)
  end
end
