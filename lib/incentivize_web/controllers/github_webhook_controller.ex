defmodule IncentivizeWeb.GithubWebhookController do
  use IncentivizeWeb, :controller
  alias Incentivize.Github.WebhookHandler

  def handle_webhook(conn, params) do
    [event] = get_req_header(conn, "x-github-event")
    action = params["action"]

    action = "#{event}.#{action}"

    WebhookHandler.handle(action, params)
    text(conn, "ok")
  end
end
