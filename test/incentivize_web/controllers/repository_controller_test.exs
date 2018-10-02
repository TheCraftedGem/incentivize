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

  test "GET /repos for anonymous user" do
    insert!(:repository, owner: "octocat", name: "Hello-World5")

    insert!(:repository,
      owner: "octocat",
      name: "PrivateRepo",
      public: false
    )

    conn = build_conn()

    conn = get(conn, repository_path(conn, :index))
    assert html_response(conn, 200) =~ "Discover"
    assert html_response(conn, 200) =~ "Hello-World5"
    refute html_response(conn, 200) =~ "PrivateRepo"
  end

  test "GET /repos", %{conn: conn} do
    insert!(:repository, owner: "octocat", name: "Hello-World5")

    conn = get(conn, repository_path(conn, :index))
    assert html_response(conn, 200) =~ "Discover"
  end

  test "GET /repos search", %{conn: conn} do
    insert!(:repository, owner: "octocat", name: "Hello-World5")
    insert!(:repository, owner: "octocat", name: "Summer")

    conn = get(conn, repository_path(conn, :index, search: [query: "sum"]))
    assert html_response(conn, 200) =~ "Summer"
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

  test "GET /repos/settings with user who has installation" do
    user = insert!(:user, github_login: "octocat")

    conn =
      build_conn()
      |> assign(:current_user, user)

    conn = get(conn, repository_path(conn, :settings))
    assert html_response(conn, 200) =~ "Connect Repositories"
    assert html_response(conn, 200) =~ "Configure"
  end

  test "GET /repos/settings with user who does not have installation", %{conn: conn} do
    conn = get(conn, repository_path(conn, :settings))
    assert html_response(conn, 200) =~ "Connect Repositories"
    assert html_response(conn, 200) =~ "Install"
  end

  test "GET /repos/:owner/:name/edit", %{conn: conn} do
    insert!(:repository, owner: "octocat", name: "Hello-World")

    conn = get(conn, repository_path(conn, :edit, "octocat", "Hello-World"))
    assert html_response(conn, 200) =~ "octocat/Hello-World"
  end

  test "GET /repos/:owner/:name/edit when not found", %{conn: conn} do
    conn = get(conn, repository_path(conn, :show, "octocat", "Hello-World5"))
    assert html_response(conn, 404)
  end

  test "PUT /repos/:owner/:name/edit", %{conn: conn} do
    insert!(:repository, owner: "octocat", name: "Hello-World")

    conn = put(conn, repository_path(conn, :edit, "octocat", "Hello-World"))
    assert redirected_to(conn) =~ repository_path(conn, :edit, "octocat", "Hello-World")
  end

  test "PUT /repos/:owner/:name/edit when not found", %{conn: conn} do
    conn = put(conn, repository_path(conn, :edit, "octocat", "Hello-World5"))
    assert html_response(conn, 404)
  end
end
