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
    case ConCache.get(:incentivize_cache, user.github_login) do
      nil ->
        case get_github_data_for_user(user) do
          {:ok, cache_data} = ok ->
            ConCache.put(:incentivize_cache, user.github_login, cache_data)
            ok

          error ->
            error
        end

      data ->
        {:ok, data}
    end
  end

  defp get_github_data_for_user(user) do
    with(
      {:ok, organizations} <- App.github_app_module().list_organizations_for_user(user),
      {:ok, github_user} <- App.github_app_module().get_user(user),
      {:ok, repos} <- App.github_app_module().list_user_repos(user)
    ) do
      organizations = transform_org_data(organizations)

      repos =
        Enum.map(repos, fn repo ->
          %{
            full_name: repo["full_name"],
            name: repo["name"],
            owner: repo["owner"]["login"],
            private: repo["private"]
          }
        end)

      {:ok,
       %{
         user: %{
           github_id: github_user["id"]
         },
         organizations: organizations,
         repos: repos
       }}
    else
      error ->
        error
    end
  end

  defp transform_org_data(organizations) do
    organizations
    |> Enum.map(fn %{"role" => role, "organization" => org} ->
      %{id: org["id"], login: org["login"], role: role}
    end)
    |> Enum.sort(fn org1, org2 ->
      String.downcase(org1.login) < String.downcase(org2.login)
    end)
  end

  def clear_user_github_data(user) do
    ConCache.delete(:incentivize_cache, user.github_login)
  end
end
