defmodule Incentivize.Github.InstallationRepository do
  @moduledoc """
  InstallationRepository Schema
  """
  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Github.Installation, Github.InstallationRepository, Repository}

  @type t :: %__MODULE__{}
  schema "github_installation_repositories" do
    belongs_to(:installation, Installation, references: :installation_id)
    belongs_to(:repository, Repository)
    timestamps()
  end

  def changeset(%InstallationRepository{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :installation_id,
      :repository_id
    ])
  end
end
