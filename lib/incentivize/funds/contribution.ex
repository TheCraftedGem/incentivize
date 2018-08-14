defmodule Incentivize.Contribution do
  @moduledoc """
  Contribution Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Contribution, Pledge, Repository, User}
  require Logger

  @type t :: %__MODULE__{}
  schema "contributions" do
    field(:amount, :decimal)
    field(:action, :string)
    field(:github_url, :string)
    field(:stellar_transaction_url, :string)
    belongs_to(:pledge, Pledge)
    belongs_to(:user, User)
    belongs_to(:repository, Repository)
    timestamps()
  end

  def changeset(%Contribution{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :amount,
      :action,
      :github_url,
      :stellar_transaction_url,
      :pledge_id,
      :user_id,
      :repository_id
    ])
    |> validate_required([
      :amount,
      :action,
      :github_url,
      :stellar_transaction_url,
      :pledge_id,
      :user_id,
      :repository_id
    ])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
  end
end
