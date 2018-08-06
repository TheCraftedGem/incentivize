defmodule Incentivize.User do
  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false

  @type t :: %__MODULE__{}
  schema "users" do
    field(:email, :string)
    field(:github_login, :string)
    field(:github_access_token, :string)
    field(:github_avatar_url, :string)
    field(:logged_in_at, :utc_datetime)
    field(:stellar_public_key, :string)
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [
      :email,
      :github_login,
      :github_access_token,
      :github_avatar_url,
      :logged_in_at,
      :stellar_public_key
    ])
    |> validate_required([:github_login, :github_access_token])
    |> update_change(:email, &String.downcase/1)
    |> update_change(:email, &String.trim/1)
    |> validate_format(:email, email_format(), message: "not a valid email address")
  end

  defp email_format do
    ~r/\A[^@]+@[^@]+\z/
  end
end
