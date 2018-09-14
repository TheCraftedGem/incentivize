defmodule Incentivize.UserFund do
  @moduledoc """
  User Schema
  """
  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Fund, User, UserFund}

  @type t :: %__MODULE__{}
  schema "user_funds" do
    belongs_to(:user, User)
    belongs_to(:fund, Fund)
    timestamps()
  end

  def changeset(%UserFund{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :user_id,
      :fund_id
    ])
  end
end
