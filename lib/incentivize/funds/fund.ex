defmodule Incentivize.Fund do
  @moduledoc """
  Fund Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Fund, Pledge, Repository, User}
  require Logger

  @type t :: %__MODULE__{}
  schema "funds" do
    field(:stellar_public_key, :string)
    belongs_to(:repository, Repository)
    has_many(:pledges, Pledge)
    belongs_to(:created_by, User)
    timestamps()
  end

  def create_changeset(%Fund{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :repository_id,
      :created_by_id
    ])
    |> validate_required([
      :repository_id,
      :created_by_id
    ])
    |> cast_assoc(:pledges, required: true)
    |> validate_pledges_present()
    |> validate_duplicate_pledges()
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

  def add_stellar_public_key_changeset(%Fund{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :stellar_public_key
    ])
    |> validate_required([
      :stellar_public_key
    ])
  end
end
