defmodule Incentivize.Notifications do
  @moduledoc """
  Handles application notifications
  """

  alias Incentivize.{EmailBuilder, EmailVerifications, Mailer}

  # 48 hours
  @email_verification_token_expiration_in_seconds 172_800

  def send_email_verification_email(user) do
    token =
      EmailVerifications.create_email_verification_token(
        user,
        user.email,
        @email_verification_token_expiration_in_seconds
      )

    user
    |> EmailBuilder.email_verification_email(user.email, token)
    |> Mailer.deliver_later()

    :ok
  end
end
