defmodule Incentivize.Repositories do
  @moduledoc """
  Module for interacting with Repositories
  """

  import Ecto.{Query}, warn: false
  alias Ecto.Multi
  alias Incentivize.{Repo, Repository, UserRepository, Users}

  def list_repositories do
    Repository
    |> order_by([r], asc: r.owner, asc: r.name)
    |> preload([:funds, :contributions])
    |> Repo.all()
  end

  def list_repositories_for_user(user) do
    Repository
    |> join(
      :inner,
      [r],
      ur in UserRepository,
      r.id == ur.repository_id and ur.user_id == ^user.id
    )
    |> order_by([r], asc: r.owner, asc: r.name)
    |> preload([:funds, :contributions])
    |> Repo.all()
  end

  def create_repository(params) do
    Multi.new()
    |> Multi.insert(:repository, Repository.create_changeset(%Repository{}, params))
    |> Multi.run(:user_repositories, fn %{repository: repo} ->
      %UserRepository{}
      |> UserRepository.changeset(%{repository_id: repo.id, user_id: repo.created_by_id})
      |> Repo.insert()
    end)
    |> Repo.transaction()
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
        where: ilike(repo.name, ^name),
        preload: [:funds, :contributions]
      )

    Repo.one(query)
  end

  def get_repository(id) do
    Repository
    |> preload([:funds, :contributions])
    |> Repo.get(id)
  end

  def user_owns_repository?(repository, user) do
    result =
      UserRepository
      |> where([ur], ur.repository_id == ^repository.id)
      |> where([ur], ur.user_id == ^user.id)
      |> Repo.one()

    result != nil
  end
end
