defmodule IncentivizeWeb.FundView do
  use IncentivizeWeb, :view
  alias Ecto.Changeset
  alias Incentivize.{Actions, Fund, Funds, Pledge}

  def can_add_assets_to_fund?(conn, fund) do
    logged_in?(conn) and Funds.can_edit_fund?(fund, conn.assigns.current_user)
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

  def fund_name(%Fund{name: name} = fund) when name in ["", nil] do
    "#{fund.created_by.github_login}'s fund"
  end

  def fund_name(%Fund{name: name}) do
    name
  end
end
