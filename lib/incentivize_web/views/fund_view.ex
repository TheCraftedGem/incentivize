defmodule IncentivizeWeb.FundView do
  use IncentivizeWeb, :view
  alias Incentivize.{Actions, Contributions, Pledge}

  def action_choices do
    actions = Actions.github_actions()
    keys = Map.keys(actions)
    values = Map.values(actions)

    Enum.zip(values, keys)
  end

  def action_display(action) do
    Actions.github_actions()[action]
  end

  def count_contributions_for_fund(fund) do
    length(Contributions.list_contributions_for_fund(fund))
  end
end
