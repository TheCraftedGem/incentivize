defmodule IncentivizeWeb.FundView do
  use IncentivizeWeb, :view
  alias Incentivize.{Actions, Funds, Pledge}
  alias Ecto.Changeset

  def supporter_owns_fund?(conn, fund) do
    logged_in?(conn) and Funds.user_owns_fund?(fund, conn.assigns.current_user)
  end

  def action_display(action) do
    Actions.github_actions()[action]
  end

  def actions_dropdown do
    keys = Map.keys(Actions.github_actions())
    values = Map.values(Actions.github_actions())

    Enum.zip(values, keys)
  end

  def pledges_with_indexes(form) do
    pledges = Changeset.get_change(form.source, :pledges, [])

    pledges =
      if Enum.empty?(pledges) do
        [Pledge.changeset(%Pledge{}, %{})]
      else
        pledges
      end

    Enum.with_index(pledges)
  end
end
