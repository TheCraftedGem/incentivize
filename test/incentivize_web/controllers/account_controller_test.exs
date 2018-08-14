defmodule IncentivizeWeb.AccountControllerTest do
  @moduledoc false
 use IncentivizeWeb.ConnCase, async: true
  alias Incentivize.Users

  setup %{conn: conn} do
    user = insert!(:user)

    conn =
      conn
      |> assign(:current_user, user)

    [user: user, conn: conn]
  end

  test "GET /account", %{conn: conn} do
    conn = get(conn, account_path(conn, :show))
    assert html_response(conn, 200) =~ "Account"
    assert html_response(conn, 200) =~ "Stellar Public Key"
  end

  test "GET /account/edit", %{conn: conn} do
    conn = get(conn, account_path(conn, :edit))
    assert html_response(conn, 200) =~ "Account"
    assert html_response(conn, 200) =~ "Stellar Public Key"
  end

  test "PUT /account/edit", %{conn: conn, user: user} do
    conn = put(conn, account_path(conn, :edit), user: [stellar_public_key: "12345"])
    assert redirected_to(conn) =~ account_path(conn, :edit)

    assert Users.get_user(user.id).stellar_public_key == "12345"
  end

  test "PUT /account/edit with bad data", %{conn: conn} do
    conn =
      put(conn, account_path(conn, :edit),
        user: [stellar_public_key: "12345", email: "notanemail"]
      )

    assert html_response(conn, 400) =~ "Account"
  end
end
