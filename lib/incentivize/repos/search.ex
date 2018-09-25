defmodule Incentivize.Repositories.Search do
  @moduledoc """
  Schema to encapsulate repository search
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.Repositories.Search

  @type t :: %__MODULE__{}
  embedded_schema do
    field(:query, :string)
    field(:page, :integer, default: 1)
  end

  def changeset(%Search{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :query,
      :page
    ])
  end
end
