defmodule IncentivizeWeb.GithubWebhookController do
  use IncentivizeWeb, :controller
  alias Incentivize.Github.WebhookHandler

  def handle_webhook(conn, params) do
    action = get_action(conn, params)

    WebhookHandler.handle(action, params)

    text(conn, "ok")
  end

  defp get_action(conn, params) do
    case get_req_header(conn, "x-github-event") do
      ["ping"] ->
        "ping"

      [event] ->
        action = params["action"]
        "#{event}.#{action}"
    end
  end
end
