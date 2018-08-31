defmodule IncentivizeWeb.FundView do
  use IncentivizeWeb, :view
  alias Incentivize.{Actions, Contributions}

  def action_display(action) do
    Actions.github_actions()[action]
  end

  def count_contributions_for_fund(fund) do
    length(Contributions.list_contributions_for_fund(fund))
  end

  def actions_dropdown do
    keys = Map.keys(Actions.github_actions())
    values = Map.values(Actions.github_actions())

    Enum.zip(values, keys)
  end

  def pledges_with_indexes(%Ecto.Association.NotLoaded{}) do
    []
  end

  def pledges_with_indexes(pledges) do
    Enum.with_index(pledges)
  end
end
