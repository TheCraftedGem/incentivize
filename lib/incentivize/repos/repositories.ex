defmodule Incentivize.Repositories do
  @moduledoc """
  Module for interacting with Repositories
  """

  import Ecto.{Query}, warn: false
  alias Ecto.Multi
  alias Incentivize.{Repo, Repository, UserRepository}

  def list_repositories do
    Repository
    |> where([r], r.public == true)
    |> where([r], is_nil(r.deleted_at))
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
    |> where([r], r.public == true)
    |> where([r], is_nil(r.deleted_at))
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
        where: is_nil(repo.deleted_at),
        preload: [:funds, :contributions]
      )

    Repo.one(query)
  end

  def get_public_repository_by_owner_and_name(owner, name) do
    query =
      from(repo in Repository,
        where: ilike(repo.owner, ^owner),
        where: ilike(repo.name, ^name),
        where: repo.public == true,
        where: is_nil(repo.deleted_at),
        preload: [:funds, :contributions]
      )

    Repo.one(query)
  end

  def get_repository_by_owner_and_name_include_deleted(owner, name) do
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

  @doc """
  Stats include:

  - the number of assets distributed
  - number of Funds created
  - the total number of contributions
  - the total number of contributors
  """
  def get_repository_stats(repository) do
    query =
      from(
        contribution in Incentivize.Contribution,
        where: contribution.repository_id == ^repository.id,
        select: sum(contribution.amount)
      )

    number_of_assets_distributed = Repo.one(query) || 0

    query =
      from(
        fund in Incentivize.Fund,
        where: fund.repository_id == ^repository.id,
        select: count(fund.id)
      )

    number_of_funds_created = Repo.one(query) || 0

    query =
      from(
        contribution in Incentivize.Contribution,
        where: contribution.repository_id == ^repository.id,
        select: count(contribution.id)
      )

    number_of_contributions = Repo.one(query) || 0

    query =
      from(
        contribution in Incentivize.Contribution,
        where: contribution.repository_id == ^repository.id,
        select: count(contribution.user_id, :distinct)
      )

    number_of_contributors = Repo.one(query) || 0

    %{
      number_of_assets_distributed: number_of_assets_distributed,
      number_of_funds_created: number_of_funds_created,
      number_of_contributions: number_of_contributions,
      number_of_contributors: number_of_contributors
    }
  end

  def user_owns_repository?(repository, user) do
    result =
      UserRepository
      |> where([ur], ur.repository_id == ^repository.id)
      |> where([ur], ur.user_id == ^user.id)
      |> Repo.one()

    result != nil
  end

  def delete_repositories_for_installation_id(installation_id) do
    Repo.update_all(
      from(r in Repository,
        where: r.installation_id == ^installation_id,
        update: [set: [deleted_at: ^DateTime.utc_now()]]
      ),
      []
    )
  end

  def delete_repositories(repositories) do
    repo_ids = Enum.map(repositories, fn x -> x.id end)

    Repo.update_all(
      from(r in Repository,
        where: r.id in ^repo_ids,
        update: [set: [deleted_at: ^DateTime.utc_now()]]
      ),
      []
    )
  end

  def delete_repository(repository) do
    Repo.update_all(
      from(r in Repository,
        where: r.id == ^repository.id,
        update: [set: [deleted_at: ^DateTime.utc_now()]]
      ),
      []
    )
  end

  def undelete_repository(repository, installation_id) do
    Repo.update_all(from(r in Repository,
      where: r.id == ^repository.id,
      update: [set: [installation_id: ^installation_id, deleted_at: nil]]
    ), [])
  end
end
