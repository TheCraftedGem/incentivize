defmodule IncentivizeWeb.GithubWebhookController.Test do
  @moduledoc false
  use IncentivizeWeb.ConnCase

  test "POST /github/webhook", %{conn: conn} do
    _repo = insert!(:repository, %{owner: "test", name: "test", webhook_secret: "12345"})

    json = File.read!("./test/fixtures/ping.json")

    conn =
      conn
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-hub-signature", "sha1=5c1c013df6e414af83d6d378d286b437592834ba")
      |> put_req_header("x-github-event", "ping")
      |> post(github_webhook_path(conn, :handle_webhook), json)

    assert response(conn, 200)
  end
end
