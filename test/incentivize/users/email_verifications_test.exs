defmodule Incentivize.EmailVerifications.Test do
  use Incentivize.DataCase, async: true
  alias Incentivize.{EmailVerifications, Users}

  test "verify_user_email when user is currently using the email" do
    user = insert!(:user)
    refute user.email_verified

    EmailVerifications.verify_user_email(user, user.email)

    user = Users.get_user(user.id)
    assert user.email_verified

    assert EmailVerifications.user_email_verified?(user, user.email)
  end

  test "verify_user_email when user is not currently using the email" do
    user = insert!(:user)
    other_email = "111111111@example.com"

    EmailVerifications.verify_user_email(user, other_email)

    user = Users.get_user(user.id)
    refute user.email_verified

    assert EmailVerifications.user_email_verified?(user, other_email)
  end

  test "verify_email_verification_token when token not expired" do
    user = insert!(:user)
    token = EmailVerifications.create_email_verification_token(user, user.email, 3000)

    assert {:ok, _user, _email} = EmailVerifications.verify_email_verification_token(token)
  end

  test "verify_email_verification_token when token expired" do
    user = insert!(:user)
    token = EmailVerifications.create_email_verification_token(user, user.email, -3000)

    assert :error = EmailVerifications.verify_email_verification_token(token)
  end
end
