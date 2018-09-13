defmodule IncentivizeWeb.FallbackController do
  use IncentivizeWeb, :controller
  alias IncentivizeWeb.ErrorView
  alias Plug.Conn

  def call(conn, :not_found) do
    conn
    |> Conn.put_status(404)
    |> render(ErrorView, "404.html")
  end
end
