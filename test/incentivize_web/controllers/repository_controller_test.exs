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

  test "GET /repos/:owner/:name with title", %{conn: conn} do
    insert!(:repository, owner: "octocat", name: "Hello-World5", title: "Hello World")

    conn = get(conn, repository_path(conn, :show, "octocat", "Hello-World5"))
    assert html_response(conn, 200) =~ "Hello World"
  end

  test "GET /repos/:owner/:name when repo private and user has access", %{conn: conn} do
    insert!(:repository, owner: "octocat", name: "Hello-World", public: false)

    conn = get(conn, repository_path(conn, :show, "octocat", "Hello-World"))
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
    repository = insert!(:repository, owner: "octocat", name: "Hello-World")

    params = %{
      "description" => "This is a test",
      "links" => %{
        "0" => %{
          "title" => "",
          "url" => ""
        },
        "1" => %{
          "title" => "",
          "url" => ""
        },
        "2" => %{
          "title" => "",
          "url" => "https://google.com"
        }
      },
      "logo_url" => "https://image.com/image.png",
      "title" => "Test title"
    }

    conn = put(conn, repository_path(conn, :edit, "octocat", "Hello-World"), repository: params)

    assert redirected_to(conn) =~ repository_path(conn, :edit, "octocat", "Hello-World")

    repo = Repositories.get_repository(repository.id)
    assert hd(repo.links).url == "https://google.com"
    assert repo.title == "Test title"
    assert repo.logo_url == "https://image.com/image.png"
    assert repo.description == "This is a test"
  end

  test "PUT /repos/:owner/:name/edit when not found", %{conn: conn} do
    conn = put(conn, repository_path(conn, :edit, "octocat", "Hello-World5"), repository: %{})
    assert html_response(conn, 404)
  end
end
