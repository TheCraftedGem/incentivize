defmodule IncentivizeWeb.FundView do
  use IncentivizeWeb, :view
  alias Incentivize.{Actions, Contributions, Funds, Pledge}

  def supporter_owns_fund?(conn, fund) do
    logged_in?(conn) and Funds.user_owns_fund?(fund, conn.assigns.current_user)
  end

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

  # def pledges_with_indexes(%Ecto.Association.NotLoaded{}) do
  #  []
  # end

  def pledges_with_indexes(form) do
    pledges = Ecto.Changeset.get_change(form.source, :pledges, [])

    pledges =
      if Enum.empty?(pledges) do
        [Pledge.changeset(%Pledge{}, %{})]
      else
        pledges
      end

    Enum.with_index(pledges)
  end
end
