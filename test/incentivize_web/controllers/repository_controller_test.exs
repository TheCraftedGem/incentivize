defmodule IncentivizeWeb.RepositoryControllerTest do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true
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
    assert html_response(conn, 200) =~ "Name"
  end

  test "POST /repos/create", %{conn: conn, user: _user} do
    conn =
      post(conn, repository_path(conn, :create),
        repository: [owner: "octocat", name: "Hello-World"]
      )

    assert redirected_to(conn) =~ repository_path(conn, :webhook, "octocat", "Hello-World")

    assert Repositories.get_repository_by_owner_and_name("octocat", "Hello-World") != nil
  end

  test "POST /repos/create with bad data", %{conn: conn} do
    conn = post(conn, repository_path(conn, :create), repository: [owner: "", name: "me"])
    assert html_response(conn, 400) =~ "Owner"

    assert Repositories.get_repository_by_owner_and_name("me", "me") == nil
  end

  test "GET /repos/:owner/:name/webhook when not authorized", %{conn: conn, user: _user} do
    insert!(:repository, owner: "octocat", name: "Hello-World")

    conn = get(conn, repository_path(conn, :webhook, "octocat", "Hello-World"))
    assert response(conn, 403) =~ "Unauthorized"
  end

  test "GET /repos/:owner/:name/webhook when authorized", %{conn: conn, user: user} do
    insert!(:repository, owner: "octocat", name: "Hello-World", admin: user)

    conn = get(conn, repository_path(conn, :webhook, "octocat", "Hello-World"))
    assert html_response(conn, 200)
  end

  test "POST /repos/create when repo already connected", %{conn: conn} do
    insert!(:repository, owner: "octocat", name: "Hello-World")

    conn =
      post(conn, repository_path(conn, :create),
        repository: [owner: "octocat", name: "Hello-World"]
      )

    assert html_response(conn, 400) =~ "already connected"
  end

  test "GET /repos", %{conn: conn} do
    insert!(:repository, owner: "octocat", name: "Hello-World")

    conn = get(conn, repository_path(conn, :index))
    assert html_response(conn, 200) =~ "Discover"
  end

  test "GET /repos/:owner/:name", %{conn: conn} do
    insert!(:repository, owner: "octocat", name: "Hello-World")

    conn = get(conn, repository_path(conn, :show, "octocat", "Hello-World"))
    assert html_response(conn, 200) =~ "octocat/Hello-World"
  end
end
