defmodule Incentivize.EmailVerification do
  @moduledoc """
  EmailVerification Schema
  """
  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{EmailVerification, User}

  @type t :: %__MODULE__{}
  schema "email_verifications" do
    belongs_to(:user, User)
    field(:email, :string)
    field(:verified_at, :utc_datetime)
    timestamps()
  end

  def changeset(%EmailVerification{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :user_id,
      :email,
      :verified_at
    ])
    |> validate_required([:user_id, :email])
  end
end
