defmodule IncentivizeWeb.FundViewTest do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true
  alias IncentivizeWeb.FundView

  test "fund_name when fund does not have a name" do
    user = insert!(:user, github_login: "bryan")
    fund = insert!(:fund, created_by: user)

    assert FundView.fund_name(fund) == "bryan's fund"
  end

  test "fund_name when fund has a name" do
    user = insert!(:user, github_login: "bryan")
    fund = insert!(:fund, created_by: user, name: "My Fund")

    assert FundView.fund_name(fund) == "My Fund"
  end
end
