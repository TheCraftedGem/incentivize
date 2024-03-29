defmodule IncentivizeWeb.FundControllerTest do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true
  alias Incentivize.{Funds}

  setup %{conn: conn} do
    user = insert!(:user)

    conn =
      conn
      |> assign(:current_user, user)

    [user: user, conn: conn]
  end

  test "GET /repos/:owner/:name/funds", %{conn: conn} do
    insert!(:repository, owner: "me", name: "me")

    conn = get(conn, fund_path(conn, :index, "me", "me"))
    assert html_response(conn, 200) =~ "Funds for"
    assert html_response(conn, 200) =~ "me/me"
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

    assert html_response(conn, 400) =~ "Pledges"

    assert Enum.empty?(Funds.list_funds_for_repository(repository)) == true
  end

  test "POST /repos/:owner/:name/funds/create fails with duplicates", %{conn: conn, user: _user} do
    repository = insert!(:repository, owner: "me", name: "me")

    conn =
      post(conn, fund_path(conn, :create, "me", "me"),
        fund: [
          pledges: %{
            "0" => %{"action" => "pull_request.opened", "amount" => "1"},
            "1" => %{"action" => "pull_request.opened", "amount" => "1"}
          }
        ]
      )

    assert html_response(conn, 400) =~ "Pledges"

    assert Enum.empty?(Funds.list_funds_for_repository(repository)) == true
  end

  test "GET /repos/:owner/:name/fund/:id", %{conn: conn, user: user} do
    repository = insert!(:repository, owner: "me", name: "me")
    fund = insert!(:fund, repository: repository, created_by: user)

    conn = get(conn, fund_path(conn, :show, "me", "me", fund.id))
    assert html_response(conn, 200) =~ "me/me"
    assert html_response(conn, 200) =~ "Add XLM"
  end

  test "GET /repos/:owner/:name/fund/:id when not fund owner and logged in", %{
    conn: conn
  } do
    repository = insert!(:repository, owner: "me", name: "me")
    fund = insert!(:fund, repository: repository)

    conn = get(conn, fund_path(conn, :show, "me", "me", fund.id))
    assert html_response(conn, 200) =~ "me/me"
    refute html_response(conn, 200) =~ "Add XLM"
  end

  test "GET /repos/:owner/:name/fund/:id when not fund owner and not logged in" do
    repository = insert!(:repository, owner: "me", name: "me")
    fund = insert!(:fund, repository: repository, description: "A fund")

    conn = build_conn()

    conn = get(conn, fund_path(conn, :show, "me", "me", fund.id))
    assert html_response(conn, 200) =~ "me/me"
    refute html_response(conn, 200) =~ "Add XLM"
  end

  test "GET /repos/:owner/:name/fund/:id when fund not found" do
    _repository = insert!(:repository, owner: "me", name: "me")

    conn = build_conn()

    conn = get(conn, fund_path(conn, :show, "me", "me", 0))
    assert html_response(conn, 404)
  end
end
