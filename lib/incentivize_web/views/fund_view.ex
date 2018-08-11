defmodule IncentivizeWeb.FundView do
  use IncentivizeWeb, :view
  alias Incentivize.{Funds, Pledge}

  def action_choices do
    actions = Funds.github_actions()
    keys = Keyword.keys(actions)
    values = Keyword.values(actions)

    Enum.zip(values, keys)
  end

  def action_display(action) when is_atom(action) do
    Funds.github_actions()[action]
  end

  def action_display(action) do
    Funds.github_actions()[String.to_atom(action)]
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
