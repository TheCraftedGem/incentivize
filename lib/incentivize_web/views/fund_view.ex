defmodule IncentivizeWeb.FundView do
  use IncentivizeWeb, :view
  alias Incentivize.{Actions, Contributions, Funds}

  def supporter_owns_fund?(conn, fund) do
    logged_in?(conn) and Funds.user_owns_fund?(fund, conn.assigns.current_user)
  end

  def action_display(action) do
    Actions.github_actions()[action]
  end

  def count_contributions_for_fund(fund) do
    length(Contributions.list_contributions_for_fund(fund))
  end
end
