defmodule Incentivize.EmailVerifications do
  @moduledoc """
  Email Verification functions
  """
  import Ecto.{Query}, warn: false
  alias Ecto.Multi
  alias Incentivize.{EmailVerification, Repo, User, Users}

  def create_new_email_verification(user, email) do
    Repo.insert(%EmailVerification{
      user_id: user.id,
      email: email
    })
  end

  def verify_user_email(user, email) do
    Multi.new()
    |> Multi.run(
      :email_verification,
      fn _ ->
        case Repo.get_by(EmailVerification, user_id: user.id, email: email) do
          nil ->
            %EmailVerification{}
            |> EmailVerification.changeset(%{
              user_id: user.id,
              email: email,
              verified_at: DateTime.utc_now()
            })
            |> Repo.insert()

          email_verification ->
            email_verification
            |> EmailVerification.changeset(%{
              verified_at: DateTime.utc_now()
            })
            |> Repo.update()
        end
      end
    )
    |> Multi.run(:user_email_verified, fn _ ->
      # if the user's current email matches the one being verified, we want to update the
      # email_verified field to true
      if user.email == email do
        user
        |> User.changeset(%{email_verified: true})
        |> Repo.update()
      else
        {:ok, user}
      end
    end)
    |> Repo.transaction()
  end

  @doc """
  Shows whether or not the email given is verified for the given user
  """
  def user_email_verified?(user, email) do
    query =
      from(verification in EmailVerification,
        where: verification.email == ^email,
        where: verification.user_id == ^user.id,
        where: not is_nil(verification.verified_at),
        select: verification
      )

    Repo.one(query) != nil
  end

  @doc """
  Shows whether or not the email given is captured for verification
  """
  def user_email_captured?(user, email) do
    Repo.get_by(EmailVerification, email: email, user_id: user.id) != nil
  end

  @doc """
  Creates an email verification token. This is meant to be sent to the
  email the user is trying to verify they control
  """
  def create_email_verification_token(user, email, expires_in_seconds) do
    import Joken

    token()
    |> with_claim("user_id", user.id)
    |> with_claim("email", email)
    |> with_claim_generator("exp", fn -> current_time() + expires_in_seconds end)
    |> with_signer(hs256(joken_key()))
    |> sign
    |> get_compact
  end

  @doc """
  Verifies the given token. This should be collected from the user, from the email
  they are trying to verify
  """
  def verify_email_verification_token(token) do
    import Joken

    verified_token =
      token
      |> token
      |> with_signer(hs256(joken_key()))
      |> with_validation("exp", &(&1 > current_time()))
      |> verify!

    case verified_token do
      {:ok, %{"user_id" => user_id, "email" => email}} ->
        case Users.get_user(user_id) do
          nil ->
            :error

          user ->
            {:ok, user, email}
        end

      {:error, _} ->
        :error
    end
  end

  defp joken_key do
    Application.get_env(:incentivize, IncentivizeWeb.Endpoint)[:secret_key_base]
  end
end
