defmodule Incentivize.Repository do
  @moduledoc """
  Repository Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Fund, Github.API.Repos, Repository, User}

  @type t :: %__MODULE__{}
  schema "repositories" do
    field(:name, :string)
    field(:owner, :string)
    field(:webhook_secret, :string)
    belongs_to(:admin, User)
    has_many(:funds, Fund)
    timestamps()
  end

  def create_changeset(%Repository{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :owner,
      :admin_id
    ])
    |> validate_required([:name, :owner, :admin_id])
    |> unique_constraint(:owner,
      name: "repositories_owner_name_index",
      message: "Repository already connected."
    )
    |> put_change(:webhook_secret, random_string(32))
    |> validate_public_repo()
  end

  def update_changeset(%Repository{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :owner,
      :webhook_secret,
      :admin_id
    ])
    |> validate_required([:name, :owner, :webhook_secret, :admin_id])
    |> validate_public_repo()
  end

  defp random_string(length) do
    length |> :crypto.strong_rand_bytes() |> Base.encode64() |> binary_part(0, length)
  end

  defp validate_public_repo(changeset) do
    owner = get_field(changeset, :owner)
    name = get_field(changeset, :name)

    if owner != nil and name != nil do
      case Repos.get_public_repo(owner, name) do
        {:ok, _} -> changeset
        _ -> add_error(changeset, :public, "private repositories are not allowed")
      end
    else
      changeset
    end
  end
end
