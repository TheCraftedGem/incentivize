defmodule Incentivize.Fund do
  @moduledoc """
  Fund Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Fund, Repository, User}

  @type t :: %__MODULE__{}
  schema "funds" do
    field(:pledge_amount, :decimal)
    field(:stellar_public_key, :string)
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
    changeset
  end

  def update_changeset(%Fund{} = model, params \\ %{}) do
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
  end
end
