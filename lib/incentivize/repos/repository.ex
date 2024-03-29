defmodule Incentivize.Repository do
  @moduledoc """
  Repository Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Contribution, Fund, Repository, RepositoryLink, User}

  @type t :: %__MODULE__{}
  schema "repositories" do
    field(:name, :string)
    field(:owner, :string)
    field(:public, :boolean, default: true)
    field(:deleted_at, :utc_datetime)
    field(:installation_id, :integer)
    has_many(:funds, Fund)
    has_many(:contributions, Contribution)
    belongs_to(:created_by, User)
    timestamps()
    field(:title, :string)
    field(:logo_url, :string)
    field(:description, :string)
    has_many(:links, RepositoryLink, on_replace: :delete)
  end

  def create_changeset(%Repository{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :owner,
      :created_by_id,
      :public,
      :installation_id
    ])
    |> validate_required([:name, :owner, :public, :installation_id])
    |> unique_constraint(:owner,
      name: "repositories_owner_name_index",
      message: "Repository already connected."
    )
  end

  def update_changeset(%Repository{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :owner,
      :created_by_id,
      :deleted_at,
      :public,
      :installation_id,
      :title,
      :description,
      :logo_url
    ])
    |> validate_required([:name, :owner, :public, :installation_id])
    |> cast_assoc(:links, required: false)
  end
end
