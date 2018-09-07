defmodule Incentivize.Fund do
  @moduledoc """
  Fund Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Fund, Pledge, Repository, User, Users}
  require Logger
  @stellar_module Application.get_env(:incentivize, :stellar_module)

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
    |> validate_pledges_present()
    |> validate_duplicate_pledges()
    |> create_stellar_fund()
    |> validate_required([:stellar_public_key])
  end

  defp validate_pledges_present(changeset) do
    pledges = get_change(changeset, :pledges, [])

    if changeset.valid? and Enum.empty?(pledges) do
      add_error(changeset, :pledges, "Must have at least one pledge")
    else
      changeset
    end
  end

  defp validate_duplicate_pledges(changeset) do
    pledges = get_change(changeset, :pledges, [])

    if changeset.valid? and Enum.empty?(pledges) == false and duplicates_exists?(pledges) do
      add_error(changeset, :pledges, "Can not have same action for multiple pledges")
    else
      changeset
    end
  end

  defp duplicates_exists?(pledges) do
    pledges
    |> Enum.group_by(fn pledge -> pledge.changes.action end)
    |> Enum.find(fn {_action, pledges} -> length(pledges) > 1 end)
  end

  defp create_stellar_fund(changeset) do
    if changeset.valid? and get_field(changeset, :supporter_id) != nil do
      user = Users.get_user(get_field(changeset, :supporter_id))

      case @stellar_module.create_fund_account(user.stellar_public_key) do
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
