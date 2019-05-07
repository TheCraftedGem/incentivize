defmodule Incentivize.Github.App.Test do
  use Incentivize.DataCase, async: true
  alias Incentivize.Github.App
  alias Plug.Conn

  setup do
    bypass = Bypass.open()
    url = "http://localhost:#{bypass.port}"
    Application.put_env(:incentivize, :github_api_base_url, url)
    {:ok, bypass: bypass}
  end

  test "public_url" do
    assert App.public_url() =~ "https://github.com/apps/"
  end

  test "get_user", %{bypass: bypass} do
    user = insert!(:user)
    json = File.read!("./test/fixtures/get_user.json")

    Bypass.expect_once(bypass, "GET", "/user", fn conn ->
      Conn.resp(conn, 200, json)
    end)

    assert {:ok, %{"login" => "octocat"}} = App.get_user(user)
  end

  test "list_user_repos", %{bypass: bypass} do
    user = insert!(:user)
    json = File.read!("./test/fixtures/list_user_repos.json")

    Bypass.expect_once(bypass, "GET", "/user/repos", fn conn ->
      Conn.resp(conn, 200, json)
    end)

    assert {:ok, [_]} = App.list_user_repos(user)
  end

  test "list_organizations_for_user", %{bypass: bypass} do
    user = insert!(:user)
    json = File.read!("./test/fixtures/list_organizations.json")

    Bypass.expect_once(bypass, "GET", "/user/memberships/orgs", fn conn ->
      Conn.resp(conn, 200, json)
    end)

    assert {:ok, [%{"login" => "github"}]} = App.list_organizations_for_user(user)
  end

  test "get_user_app_installation_by_github_login", %{bypass: bypass} do
    json = File.read!("./test/fixtures/find_user_installation.json")

    Bypass.expect_once(bypass, "GET", "/users/octocat/installation", fn conn ->
      Conn.resp(conn, 200, json)
    end)

    assert {:ok, %{"id" => 3}} = App.get_user_app_installation_by_github_login("octocat")
  end

  test "get_organization_app_installation_by_github_login", %{bypass: bypass} do
    json = File.read!("./test/fixtures/find_organization_installation.json")

    Bypass.expect_once(bypass, "GET", "/orgs/github/installation", fn conn ->
      Conn.resp(conn, 200, json)
    end)

    assert {:ok, %{"id" => 1}} = App.get_organization_app_installation_by_github_login("github")
  end

  test "get_installation_access_token", %{bypass: bypass} do
    json = File.read!("./test/fixtures/create_installation_access_token.json")
    installation_id = 12_345

    Bypass.expect_once(
      bypass,
      "POST",
      "/app/installations/#{installation_id}/access_tokens",
      fn conn ->
        Conn.resp(conn, 201, json)
      end
    )

    assert {:ok, %{"token" => "v1.1f699f1069f60xxx"}} =
             App.get_installation_access_token(installation_id)
  end
end
