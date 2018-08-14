defmodule Incentivize.Repositories do
  @moduledoc """
  Module for interacting with Repositories
  """

  import Ecto.{Query}, warn: false
  alias Incentivize.{Repo, Repository}

  def list_repositories do
    Repository
    |> order_by([r], asc: r.owner, asc: r.name)
    |> Repo.all()
  end

  def list_repositories_for_user(user) do
    Repository
    |> where([r], r.admin_id == ^user.id)
    |> order_by([r], asc: r.owner, asc: r.name)
    |> Repo.all()
  end

  def create_repository(params) do
    %Repository{}
    |> Repository.create_changeset(params)
    |> Repo.insert()
  end

  def update_repository(repository, params) do
    repository
    |> Repository.update_changeset(params)
    |> Repo.update()
  end

  def get_repository_by_owner_and_name(owner, name) do
    query =
      from(repo in Repository,
        where: ilike(repo.owner, ^owner),
        where: ilike(repo.name, ^name)
      )

    Repo.one(query)
  end

  def get_repository(id) do
    Repo.get(Repository, id)
  end

  def user_owns_repository?(repository, user) do
    user.id == repository.admin_id
  end
end
