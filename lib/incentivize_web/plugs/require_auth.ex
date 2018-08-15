defmodule IncentivizeWeb.RequireAuth do
  @moduledoc """
  Ensures user is logged in
  """

  import Plug.Conn
  alias IncentivizeWeb.Router.Helpers
  alias Phoenix.Controller

  def init(opts) do
    opts
  end

  def call(conn, _) do
    case conn.assigns.current_user do
      nil ->
        conn
        |> Controller.put_flash(:error, "Please log in before accessing requested page.")
        |> Controller.redirect(to: Helpers.page_path(conn, :index))
        |> halt

      _user ->
        conn
    end
  end
end
