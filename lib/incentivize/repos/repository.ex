defmodule Incentivize.Repository do
  @moduledoc """
  Repository Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.User

  @type t :: %__MODULE__{}
  schema "repositories" do
    field(:name, :string)
    field(:owner, :string)
    field(:webhook_secret, :string)
    belongs_to(:admin, User)
    timestamps()
  end

  def create_changeset(model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :owner,
      :admin_id
    ])
    |> validate_required([:name, :owner, :admin_id])
    |> put_change(:webhook_secret, random_string(32))
  end

  def update_changeset(model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :owner,
      :webhook_secret,
      :admin_id
    ])
    |> validate_required([:name, :owner, :webhook_secret, :admin_id])
  end

  defp random_string(length) do
    length |> :crypto.strong_rand_bytes() |> Base.encode64() |> binary_part(0, length)
  end
end