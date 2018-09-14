defmodule Incentivize.Users.Test do
  use Incentivize.DataCase, async: true
  alias Incentivize.Users

  test "create" do
    {:ok, user} =
      Users.create_user(%{
        "email" => "joe@example.com",
        "github_access_token" => "hi",
        "github_login" => "hi"
      })

    assert user.email == "joe@example.com"
  end

  test "update" do
    user = insert!(:user)

    {:ok, user} =
      Users.update_user(user, %{
        "email" => "111111111@example.com"
      })

    assert user.email == "111111111@example.com"
  end

  test "get_user_by_email" do
    user = insert!(:user)
    user_from_db = Users.get_user_by_email(user.email)

    assert user.email == user_from_db.email
  end

  test "get_user_by_github_login" do
    user = insert!(:user)
    user_from_db = Users.get_user_by_github_login(user.github_login)

    assert user.email == user_from_db.email
  end

  test "get_user" do
    user = insert!(:user)
    user_from_db = Users.get_user(user.id)

    assert user.email == user_from_db.email
  end

  test "create_or_update_user_by_github_login with existing user" do
    user = insert!(:user)

    {:ok, user_from_db} =
      Users.create_or_update_user_by_github_login(user.github_login, %{
        "email" => "111111111@example.com"
      })

    assert user_from_db.email == "111111111@example.com"
  end

  test "create_or_update_user_by_github_login without existing user" do
    {:ok, user_from_db} =
      Users.create_or_update_user_by_github_login("testuser12345", %{
        "github_login" => "testuser12345",
        "email" => "111111111@example.com",
        "github_access_token" => "12345"
      })

    assert user_from_db.github_login == "testuser12345"
    assert user_from_db.email == "111111111@example.com"
  end
end
