defmodule Incentivize.Organization do
  @moduledoc """
  Organization Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Organization, User}

  @type t :: %__MODULE__{}
  schema "organizations" do
    field(:name, :string)
    field(:slug, :string)
    belongs_to(:created_by, User)
    timestamps()
  end

  def changeset(%Organization{} = data, params \\ %{}) do
    data
    |> cast(params, [:name, :created_by_id])
    |> validate_required([:name, :created_by_id])
    |> validate_length(:name, min: 3, max: 100)
    |> validate_format(:name, ~r/[A-Za-z0-9]/)
    |> add_slug()
    |> unique_constraint(:name,
      name: "organizations_lower_name_index",
      message: "Organization name taken."
    )
    |> unique_constraint(:slug)
  end

  defp add_slug(changeset) do
    name = get_change(changeset, :name)

    if name != nil do
      put_change(changeset, :slug, Slugger.slugify_downcase(name))
    else
      changeset
    end
  end
end
