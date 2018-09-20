defmodule IncentivizeWeb.GithubWebhookController.Test do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true

  def calculate_signature(json) do
    secret = Application.get_env(:incentivize, Incentivize.Github, [])[:webhook_secret]

    "sha1=" <> (:crypto.hmac(:sha, secret, json) |> Base.encode16(case: :lower))
  end

  test "POST /github/webhook", %{conn: conn} do
    _repo =
      insert!(:repository, %{owner: "Codertocat", name: "Hello-World", webhook_secret: "12345"})

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
