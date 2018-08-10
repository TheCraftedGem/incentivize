defmodule Incentivize.Fund do
  @moduledoc """
  Fund Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Fund, Pledge, Repository, Stellar, User, Users}
  require Logger

  @type t :: %__MODULE__{}
  schema "funds" do
    field(:stellar_public_key, :string)
    belongs_to(:supporter, User)
    belongs_to(:repository, Repository)
    has_many(:pledges, Pledge)
    timestamps()
  end

  def create_changeset(%Fund{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :supporter_id,
      :repository_id
    ])
    |> validate_required([
      :supporter_id,
      :repository_id
    ])
    |> cast_assoc(:pledges, required: true)
    |> create_stellar_fund()
    |> validate_required([:stellar_public_key])
  end

  defp create_stellar_fund(changeset) do
    if get_field(changeset, :supporter_id) do
      user = Users.get_user(get_field(changeset, :supporter_id))

      case Stellar.create_fund_account(user.stellar_public_key) do
        {:ok, escrow_public_key} ->
          put_change(changeset, :stellar_public_key, escrow_public_key)

        {:error, error} ->
          Logger.error(error)
          add_error(changeset, :stellar_public_key, "failed to create Stellar account")
      end
    else
      changeset
    end
  end
end
