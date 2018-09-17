defmodule Incentivize.Repository do
  @moduledoc """
  Repository Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Contribution, Fund, Repository}

  @type t :: %__MODULE__{}
  schema "repositories" do
    field(:name, :string)
    field(:owner, :string)
    field(:webhook_secret, :string)
    has_many(:funds, Fund)
    has_many(:contributions, Contribution)
    timestamps()
  end

  def create_changeset(%Repository{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :owner
    ])
    |> validate_required([:name, :owner])
    |> unique_constraint(:owner,
      name: "repositories_owner_name_index",
      message: "Repository already connected."
    )
    |> put_change(:webhook_secret, random_string(32))
  end

  def update_changeset(%Repository{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :owner,
      :webhook_secret
    ])
    |> validate_required([:name, :owner, :webhook_secret])
  end

  defp random_string(length) do
    length |> :crypto.strong_rand_bytes() |> Base.encode64() |> binary_part(0, length)
  end
end
