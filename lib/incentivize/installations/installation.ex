defmodule Incentivize.Installation do
  @moduledoc """
  Repository Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.Installation

  @type t :: %__MODULE__{}
  schema "installations" do
    field(:installation_id, :integer)
    field(:github_login, :string)
    field(:github_login_type, :string)
    timestamps()
  end

  def changeset(%Installation{} = schema, params \\ %{}) do
    schema
    |> cast(params, [
      :installation_id,
      :github_login,
      :github_login_type
    ])
    |> validate_required([
      :installation_id,
      :github_login,
      :github_login_type
    ])
  end
end
