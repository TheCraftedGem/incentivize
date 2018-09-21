defmodule Incentivize.Users do
  @moduledoc """
  Module for interacting with Users
  """

  import Ecto.{Query}, warn: false
  alias Incentivize.{Github.App, Repo, User}

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

  @doc """
  Gets data needed from github for the given user.
  This data is cached and read from cache at this point
  up until the cache expires.
  """
  def get_user_github_data(user) do
    ConCache.get_or_store(:incentivize_cache, user.github_login, fn ->
      {:ok, organizations} = App.github_app_module().list_organizations_for_user(user)

      {:ok, github_user} = App.github_app_module().get_user(user)

      organizations =
        organizations
        |> Enum.map(fn org ->
          %{id: org["id"], login: org["login"]}
        end)
        |> Enum.sort(fn org1, org2 ->
          String.downcase(org1.login) < String.downcase(org2.login)
        end)

      {:ok, private_repos} = App.github_app_module().list_user_private_repos(user)

      private_repos =
        private_repos
        |> Enum.map(fn repo ->
          %{
            full_name: repo["full_name"],
            name: repo["name"],
            owner: repo["owner"]["login"],
            private: repo["private"]
          }
        end)

      %{
        user: %{
          github_id: github_user["id"]
        },
        organizations: organizations,
        private_repos: private_repos
      }
    end)
  end

  def clear_user_github_data(user) do
    ConCache.delete(:incentivize_cache, user.github_login)
  end
end
