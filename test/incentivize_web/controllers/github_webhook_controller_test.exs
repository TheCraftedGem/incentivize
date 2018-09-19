defmodule IncentivizeWeb.GithubWebhookController.Test do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true

  test "POST /github/webhook with no repo", %{conn: conn} do
    json = File.read!("./test/fixtures/ping.json")

    conn =
      conn
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-hub-signature", "sha1=5c1c013df6e414af83d6d378d286b437592834ba")
      |> put_req_header("x-github-event", "ping")
      |> post(github_webhook_path(conn, :handle_webhook), json)

    assert response(conn, 403)
  end

  test "POST /github/webhook", %{conn: conn} do
    _repo =
      insert!(:repository, %{owner: "Codertocat", name: "Hello-World", webhook_secret: "12345"})

    json = File.read!("./test/fixtures/issue_comment_created.json")

    conn =
      conn
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-hub-signature", "sha1=e825f1949074ee4184f5262ad2aee42a16160ae1")
      |> put_req_header("x-github-event", "issue_comment")
      |> post(github_webhook_path(conn, :handle_webhook), json)

    assert response(conn, 200)
  end
end
