defmodule IncentivizeWeb.RequireStellarKey do
  @moduledoc """
  Ensures user has a stellar key.
  If not, redirects to account edit page
  """

  import Plug.Conn
  alias IncentivizeWeb.Router.Helpers
  alias Phoenix.Controller

  def init(opts) do
    opts
  end

  def call(conn, _) do
    user = conn.assigns.current_user

    missing_stellar_key? =
      user != nil and (user.stellar_public_key == nil or user.stellar_public_key == "")

    if missing_stellar_key? && conn.request_path != Helpers.account_path(conn, :edit) do
      conn
      |> Controller.put_flash(
        :error,
        "Please enter your Stellar public key before accessing this resource"
      )
      |> Controller.redirect(to: Helpers.account_path(conn, :edit))
      |> halt
    else
      conn
    end
  end
end
