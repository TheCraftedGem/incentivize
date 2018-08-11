defmodule IncentivizeWeb.FundView do
  use IncentivizeWeb, :view
  alias Incentivize.{Funds, Pledge, Actions}

  def action_choices do
    actions = Actions.github_actions()
    keys = Map.keys(actions)
    values = Map.values(actions)

    Enum.zip(values, keys)
  end

  def action_display(action) do
    Actions.github_actions()[action]
  end

  def blank_pledge_row(changeset) do
    cond do
      Ecto.assoc_loaded?(changeset.data.pledges) == false ->
        []

      length(changeset.data.pledges) > 0 ->
        []

      true ->
        [%Pledge{}]
    end
  end
end
