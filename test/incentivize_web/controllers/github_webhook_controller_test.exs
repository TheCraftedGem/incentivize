defmodule IncentivizeWeb.GithubWebhookController.Test do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true

  def calculate_signature(json) do
    secret = Application.get_env(:incentivize, Incentivize.Github.App, [])[:webhook_secret]
    hmac = :crypto.hmac(:sha, secret, json)

    "sha1=" <> Base.encode16(hmac, case: :lower)
  end

  test "POST /github/webhook", %{conn: conn} do
    _repo = insert!(:repository, %{owner: "Codertocat", name: "Hello-World"})

    json = File.read!("./test/fixtures/issue_comment_created.json")
    signature = calculate_signature(json)

    conn =
      conn
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-hub-signature", signature)
      |> put_req_header("x-github-event", "issue_comment")
      |> post(github_webhook_path(conn, :handle_webhook), json)

    assert response(conn, 200)
  end
end
