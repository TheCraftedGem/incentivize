defmodule IncentivizeWeb.GithubWebhookController do
  use IncentivizeWeb, :controller
  alias Incentivize.Github.WebhookHandler

  def handle_webhook(conn, params) do
    WebhookHandler.handle(params)
    text(conn, "ok")
  end
end
