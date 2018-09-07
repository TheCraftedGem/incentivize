defmodule Incentivize.Pledge do
  @moduledoc """
  Pledge Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Fund, Pledge}
  require Logger

  @type t :: %__MODULE__{}
  schema "pledges" do
    field(:amount, :decimal, default: Decimal.new(0))

    # intending action to be like 'issues.opened'. Exactly how probot does things https://probot.github.io/docs/webhooks/
    field(:action, :string)
    belongs_to(:fund, Fund)
    timestamps()
  end

  def changeset(%Pledge{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :amount,
      :action,
      :fund_id
    ])
    |> validate_required([
      :amount,
      :action
    ])
    |> validate_number(:amount, greater_than: 0)
    |> unique_constraint(
      :fund_id,
      index: :pledges_fund_id_action_index,
      message: "Can not have same action for multiple pledges"
    )
  end
end
