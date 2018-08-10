defmodule Incentivize.Fund do
  @moduledoc """
  Fund Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Fund, Repository, Stellar, User, Users}

  @type t :: %__MODULE__{}
  schema "funds" do
    field(:pledge_amount, :decimal)
    field(:stellar_public_key, :string)

    # intending actions to be like 'issues.opened'. Exactly how probot does things https://probot.github.io/docs/webhooks/
    field(:actions, {:array, :string}, default: [])
    belongs_to(:supporter, User)
    belongs_to(:repository, Repository)
    timestamps()
  end

  def create_changeset(%Fund{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :pledge_amount,
      :actions,
      :supporter_id,
      :repository_id
    ])
    |> validate_required([
      :pledge_amount,
      :actions,
      :supporter_id,
      :repository_id
    ])
    |> validate_number(:pledge_amount, greater_than: 0)
    |> create_stellar_fund()
  end

  defp create_stellar_fund(changeset) do
    if get_field(changeset, :supporter_id) do
      # TODO: make this work
      # user = Users.get_user(get_field(changeset, :supporter_id))
      # escrow_public_key = Stellar.create_fund_account(user.stellar_public_key)
      # changeset = put_change(changeset, :stellar_public_key, escrow_public_key)

      changeset
    else
      changeset
    end
  end
end
