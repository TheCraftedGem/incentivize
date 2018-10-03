defmodule Incentivize.RepositoryLink do
  @moduledoc """
  RepositoryLink Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Repository, RepositoryLink}

  @type t :: %__MODULE__{}
  schema "repository_links" do
    field(:title, :string)
    field(:url, :string)
    belongs_to(:repository, Repository)
    timestamps()
  end

  def changeset(%RepositoryLink{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :title,
      :url,
      :repository_id
    ])
    |> validate_required([:url])
  end
end
