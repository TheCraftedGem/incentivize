defmodule Incentivize.Users do
  @moduledoc """
  Module for interacting with Users
  """

  import Ecto.{Query}, warn: false
  alias Incentivize.{Repo, User}

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def update_user(user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_user_by_github_login(github_login) do
    Repo.get_by(User, github_login: github_login)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def create_or_update_user_by_github_login(github_login, params) do
    case get_user_by_github_login(github_login) do
      nil ->
        create_user(params)

      user ->
        update_user(user, params)
    end
  end
end
