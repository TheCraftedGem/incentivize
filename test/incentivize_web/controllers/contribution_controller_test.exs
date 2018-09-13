defmodule IncentivizeWeb.ContributionControllerTest do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true

  setup %{conn: conn} do
    user = insert!(:user)

    conn =
      conn
      |> assign(:current_user, user)

    [user: user, conn: conn]
  end

  test "GET Contributions for Repo", %{conn: conn} do
    insert!(:repository, owner: "me", name: "me")

    conn = get(conn, contribution_path(conn, :for_repository, "me", "me"))
    assert html_response(conn, 200) =~ "Contributions"
  end

  test "GET Contributions for Repo when repo not found", %{conn: conn} do
    conn = get(conn, contribution_path(conn, :for_repository, "me", "me"))
    assert html_response(conn, 404)
  end

  test "GET Contributions for fund", %{conn: conn, user: user} do
    repository = insert!(:repository, owner: "me", name: "me")
    fund = insert!(:fund, repository: repository, supporter: user)

    conn = get(conn, contribution_path(conn, :for_fund, "me", "me", fund.id))
    assert html_response(conn, 200) =~ "Contributions"
  end

  test "GET Contributions for fund when fund not found", %{conn: conn} do
    _repository = insert!(:repository, owner: "me", name: "me")

    conn = get(conn, contribution_path(conn, :for_fund, "me", "me", 0))
    assert html_response(conn, 404)
  end
end
