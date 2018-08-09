defmodule IncentivizeWeb.FundView do
  use IncentivizeWeb, :view
  alias Incentivize.Funds

  def action_choices do
    actions = Funds.github_actions()
    keys = Keyword.keys(actions)
    values = Keyword.values(actions)

    Enum.zip(values, keys)
  end

  def action_display(action) do
    Funds.github_actions()[String.to_atom(action)]
  end
end
