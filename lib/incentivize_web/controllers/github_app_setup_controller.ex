defmodule IncentivizeWeb.GithubAppSetupController do
  use IncentivizeWeb, :controller
  alias Incentivize.Github.OAuth, as: GitHub

  def index(conn, %{"installation_id" => _, "setup_action" => _}) do
    redirect(conn, external: GitHub.authorize_url!())
  end
end
