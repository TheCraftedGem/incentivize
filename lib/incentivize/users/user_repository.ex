defmodule Incentivize.UserRepository do
  @moduledoc """
  UserRepository Schema
  """
  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Repository, User, UserRepository}

  @type t :: %__MODULE__{}
  schema "user_repositories" do
    belongs_to(:user, User)
    belongs_to(:repository, Repository)
    timestamps()
  end

  def changeset(%UserRepository{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :user_id,
      :repository_id
    ])
  end
end
