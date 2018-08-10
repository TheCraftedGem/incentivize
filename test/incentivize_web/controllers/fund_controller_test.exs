defmodule IncentivizeWeb.FundControllerTest do
  @moduledoc false
  use IncentivizeWeb.ConnCase
  alias Incentivize.{Funds}

  setup %{conn: conn} do
    user = insert!(:user)

    conn =
      conn
      |> assign(:current_user, user)

    [user: user, conn: conn]
  end

  test "GET /repos/:owner/:name/funds/new", %{conn: conn} do
    insert!(:repository, owner: "me", name: "me")

    conn = get(conn, fund_path(conn, :new, "me", "me"))
    assert html_response(conn, 200) =~ "Pledges"
    assert html_response(conn, 200) =~ "me/me"
  end

  test "POST /repos/:owner/:name/funds/create", %{conn: conn, user: _user} do
    repository = insert!(:repository, owner: "me", name: "me")

    conn =
      post(conn, fund_path(conn, :create, "me", "me"),
        fund: [
          pledges: %{"0" => %{"action" => "pull_request.opened", "amount" => "1"}}
        ]
      )

    assert redirected_to(conn) =~ "/repos/me/me/funds/"

    assert Enum.empty?(Funds.list_funds_for_repository(repository)) == false
  end

  test "POST /repos/create with bad data", %{conn: conn} do
    repository = insert!(:repository, owner: "me", name: "me")

    conn =
      post(conn, fund_path(conn, :create, "me", "me"),
        fund: [
          pledges: %{}
        ]
      )

    assert html_response(conn, 400) =~ "Fund"

    assert Enum.empty?(Funds.list_funds_for_repository(repository)) == true
  end

  test "GET /repos/:owner/:name", %{conn: conn, user: user} do
    repository = insert!(:repository, owner: "me", name: "me")
    fund = insert!(:fund, repository: repository, supporter: user)

    conn = get(conn, fund_path(conn, :show, "me", "me", fund.id))
    assert html_response(conn, 200) =~ "me/me"
  end
end
