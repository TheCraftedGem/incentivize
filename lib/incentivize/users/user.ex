defmodule Incentivize.User do
  @moduledoc """
  User Schema
  """
  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Contribution, EmailVerifications, User}

  @type t :: %__MODULE__{}
  schema "users" do
    field(:email, :string)
    field(:email_verified, :boolean, default: false)
    field(:github_login, :string)
    field(:github_access_token, :string)
    field(:github_avatar_url, :string)
    field(:logged_in_at, :utc_datetime)
    field(:stellar_public_key, :string)
    has_many(:contributions, Contribution)
    timestamps()
  end

  def changeset(%User{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :email,
      :github_login,
      :github_access_token,
      :github_avatar_url,
      :logged_in_at,
      :stellar_public_key,
      :email_verified
    ])
    |> validate_required([:github_login, :github_access_token])
    |> update_change(:email, &String.downcase/1)
    |> update_change(:email, &String.trim/1)
    |> validate_format(:email, email_format(), message: "not a valid email address")
    |> put_email_verification_status()
  end

  def put_email_verification_status(changeset) do
    update? = not is_nil(changeset.data.inserted_at)

    email = get_field(changeset, :email)

    # if we are updating the user and there is an email and
    # we aren't explicitly setting email_verified, update email_verified field
    if update? and not is_nil(email) and is_nil(get_change(changeset, :email_verified)) do
      put_change(
        changeset,
        :email_verified,
        EmailVerifications.user_email_verified?(changeset.data, email)
      )
    else
      changeset
    end
  end

  defp email_format do
    ~r/\A[^@]+@[^@]+\z/
  end
end
