defmodule incentivizeWeb.PageController do
  use incentivizeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
