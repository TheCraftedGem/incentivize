defmodule IncentivizeWeb.PageControllerTest do
  use IncentivizeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome"
  end
end
