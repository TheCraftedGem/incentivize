defmodule IncentivizeWeb.AccountControllerTest do
  use IncentivizeWeb.ConnCase
  alias Incentivize.Users

  test "GET /account/edit", %{conn: conn} do
    user = insert!(:user)

    conn =
      conn
      |> assign(:current_user, user)

    conn = get(conn, account_path(conn, :edit))
    assert html_response(conn, 200) =~ "Account"
    assert html_response(conn, 200) =~ "Stellar Public Key"
  end

  test "PUT /account/edit", %{conn: conn} do
    user = insert!(:user)

    conn =
      conn
      |> assign(:current_user, user)

    conn = put(conn, account_path(conn, :edit), user: [stellar_public_key: "12345"])
    assert redirected_to(conn) =~ account_path(conn, :edit)

    assert Users.get_user(user.id).stellar_public_key == "12345"
  end

  test "PUT /account/edit with bad data", %{conn: conn} do
    user = insert!(:user)

    conn =
      conn
      |> assign(:current_user, user)

    conn =
      put(conn, account_path(conn, :edit),
        user: [stellar_public_key: "12345", email: "notanemail"]
      )

    assert html_response(conn, 400) =~ "Account"
  end
end
