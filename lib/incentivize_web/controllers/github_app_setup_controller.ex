defmodule IncentivizeWeb.GithubAppSetupController do
  use IncentivizeWeb, :controller
  alias Incentivize.Github.{App, Installations}
  alias Incentivize.Github.OAuth, as: GitHub

  def index(conn, %{"installation_id" => installation_id, "setup_action" => "install"}) do
    with {:ok, installation_info} <- App.get_app_installation(installation_id),
         params = %{
           installation_id: installation_id,
           login: installation_info["account"]["login"],
           login_type: installation_info["target_type"]
         },
         {:ok, _installation} <- Installations.create_installation(params) do
      redirect(conn, external: GitHub.authorize_url!())
    else
      error ->
        IO.inspect(error)

        conn
        |> put_flash(:error, "Failed to create.")
        |> redirect(to: "/")
    end
  end
end
