defmodule Incentivize.Github.Installation do
  @moduledoc """
  Repository Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.Github.Installation

  @type t :: %__MODULE__{}
  schema "github_installations" do
    field(:installation_id, :integer)
    field(:login, :string)
    field(:login_type, :string)
    timestamps()
  end

  def changeset(%Installation{} = schema, params \\ %{}) do
    schema
    |> cast(params, [
      :installation_id,
      :login,
      :login_type
    ])
    |> validate_required([
      :installation_id,
      :login,
      :login_type
    ])
  end
end
