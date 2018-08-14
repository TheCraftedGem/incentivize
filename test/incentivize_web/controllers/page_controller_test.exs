defmodule IncentivizeWeb.PageControllerTest do
  @moduledoc false
 use IncentivizeWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Incentivize"
  end

  test "GET /styleguide", %{conn: conn} do
    conn = get(conn, "/styleguide")
    assert html_response(conn, 200) =~ "Incentivize"
  end
end
