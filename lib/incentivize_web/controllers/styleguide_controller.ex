defmodule IncentivizeWeb.StyleguideController do
  use IncentivizeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
