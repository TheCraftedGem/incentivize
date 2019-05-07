defmodule Incentivize.Repositories do
  @moduledoc """
  Module for interacting with Repositories
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Contribution, Fund, Funds, Repo, Repository, Repositories.Search, Users}

  def list_repositories_for_user(user, search_params) do
    number_of_contributions =
      from(
        contribution in Contribution,
        group_by: contribution.repository_id,
        select: %{
          repository_id: contribution.repository_id,
          count: count(contribution.id)
        }
      )

    number_of_funds =
      from(
        fund in Fund,
        group_by: fund.repository_id,
        select: %{
          repository_id: fund.repository_id,
          count: count(fund.id)
        }
      )

    total_sum_of_contribution_assets =
      from(
        contribution in Contribution,
        group_by: contribution.repository_id,
        select: %{
          repository_id: contribution.repository_id,
          sum: sum(contribution.amount)
        }
      )

    fund_public_keys =
      from(
        fund in Fund,
        select: %{
          stellar_public_key: fund.stellar_public_key
        }
      )

    query =
      Repository
      |> join(
        :left,
        [r],
        number_of_contribution in subquery(number_of_contributions),
        number_of_contribution.repository_id == r.id
      )
      |> join(
        :left,
        [r, number_of_contribution],
        number_of_fund in subquery(number_of_funds),
        number_of_fund.repository_id == r.id
      )
      |> join(
        :left,
        [r, number_of_contribution, number_of_fund],
        total_sum_of_contribution_asset in subquery(total_sum_of_contribution_assets),
        total_sum_of_contribution_asset.repository_id == r.id
      )
      |> preload(funds: ^fund_public_keys)
      |> where(
        [r, _number_of_contribution, _number_of_fund, _total_sum_of_contribution_asset],
        is_nil(r.deleted_at)
      )
      |> order_by([r], asc: r.owner, asc: r.name)
      |> select([r, number_of_contribution, number_of_fund, total_sum_of_contribution_asset], %{
        funds: r,
        id: r.id,
        name: r.name,
        owner: r.owner,
        public: r.public,
        deleted_at: r.deleted_at,
        installation_id: r.installation_id,
        title: r.title,
        logo_url: r.logo_url,
        description: r.description,
        number_of_contributions: number_of_contribution.count,
        number_of_funds: number_of_fund.count,
        total_sum_of_contribution_assets: total_sum_of_contribution_asset.sum
      })

    query =
      if is_nil(user) do
        query
        |> where([r], r.public == true)
      else
        repo_full_names = get_repo_full_names(user)

        query
        |> where(
          [r],
          r.public == true or fragment("(owner || '/' || name)") in ^repo_full_names
        )
      end

    repo_collection = search_and_page(query, search_params)
    # transform fund public keys into a useable list instead of a bunch of maps
    Map.update(repo_collection, :entries, [], fn entries ->
      Enum.map(entries, fn repo ->
        Map.update(repo, :funds, [], fn r ->
          Enum.map(r.funds, fn fund -> fund.stellar_public_key end)
        end)
      end)
    end)
  end

  defp search_and_page(query, search_params) do
    {:ok, search} =
      %Search{}
      |> Search.changeset(search_params)
      |> apply_action(:insert)

    query =
      if is_nil(search.query) do
        query
      else
        search_term = "%#{search.query}%"

        where(query, [r], ilike(r.owner, ^search_term) or ilike(r.name, ^search_term))
      end

    Repo.paginate(query, page: search.page)
  end

  def list_repositories_for_installation(installation_id) do
    Repository
    |> where(
      [r],
      r.installation_id == ^installation_id
    )
    |> where([r], is_nil(r.deleted_at))
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
        where: ilike(repo.name, ^name),
        where: is_nil(repo.deleted_at),
        preload: [:funds, :contributions, :links]
      )

    Repo.one(query)
  end

  def get_repository_by_owner_and_name_include_deleted(owner, name) do
    query =
      from(repo in Repository,
        where: ilike(repo.owner, ^owner),
        where: ilike(repo.name, ^name),
        preload: [:funds, :contributions, :links]
      )

    Repo.one(query)
  end

  def get_repository(id) do
    Repository
    |> preload([:funds, :contributions, :links])
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
        contribution in Contribution,
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
        contribution in Contribution,
        where: contribution.repository_id == ^repository.id,
        select: count(contribution.id)
      )

    number_of_contributions = Repo.one(query) || 0

    query =
      from(
        contribution in Contribution,
        where: contribution.repository_id == ^repository.id,
        select: count(contribution.user_id, :distinct)
      )

    number_of_contributors = Repo.one(query) || 0

    leaderboard_top_number = 5

    query =
      from(
        contribution in Contribution,
        join: user in Incentivize.User,
        on: user.id == contribution.user_id,
        where: contribution.repository_id == ^repository.id,
        group_by: [user.github_login, user.github_avatar_url],
        select: %{
          github_login: user.github_login,
          github_avatar_url: user.github_avatar_url,
          count: count(contribution.id)
        },
        order_by: [desc: count(contribution.id)],
        limit: ^leaderboard_top_number
      )

    most_contributions = Repo.all(query)

    query =
      from(
        contribution in Contribution,
        join: pledge in Incentivize.Pledge,
        on: pledge.id == contribution.pledge_id,
        join: fund in Incentivize.Fund,
        on: fund.id == pledge.fund_id,
        join: user in Incentivize.User,
        on: user.id == fund.created_by_id,
        where: contribution.repository_id == ^repository.id,
        group_by: [fund.id],
        select: %{
          fund_id: fund.id,
          sum: sum(contribution.amount)
        },
        order_by: [desc: sum(contribution.amount)],
        limit: ^leaderboard_top_number
      )

    most_active_funds = Repo.all(query)

    most_active_funds =
      Enum.map(most_active_funds, fn %{fund_id: fund_id, sum: sum} ->
        fund = Funds.get_fund(fund_id)

        %{
          fund: fund,
          sum: sum
        }
      end)

    query =
      from(
        fund in Fund,
        where: fund.repository_id == ^repository.id,
        select: %{
          public_key: fund.stellar_public_key
        }
      )

    total_fund_balance = Repo.all(query)

    total_fund_balance = Enum.map(total_fund_balance, fn fund -> fund.public_key end)

    %{
      number_of_assets_distributed: number_of_assets_distributed,
      number_of_funds_created: number_of_funds_created,
      number_of_contributions: number_of_contributions,
      number_of_contributors: number_of_contributors,
      most_contributions: most_contributions,
      most_active_funds: most_active_funds,
      total_fund_balance: total_fund_balance
    }
  end

  @spec can_view_repository?(Repository.t(), User.t()) :: boolean()
  def can_view_repository?(nil, _) do
    false
  end

  def can_view_repository?(repository, nil) do
    repository.public
  end

  def can_view_repository?(repository, user) do
    repo_full_names = get_repo_full_names(user)

    repository.public == true or
      Enum.any?(repo_full_names, fn x ->
        x == "#{repository.owner}/#{repository.name}"
      end)
  end

  @spec can_edit_repository?(Repository.t(), User.t()) :: boolean()
  def can_edit_repository?(nil, _) do
    false
  end

  def can_edit_repository?(_, nil) do
    false
  end

  def can_edit_repository?(repository, user) do
    repo_full_names = get_repo_full_names(user)

    Enum.any?(repo_full_names, fn x ->
      x == "#{repository.owner}/#{repository.name}"
    end)
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

  @doc """
  Undeletes a previously deleted repository
  """
  def undelete_repository(repository, installation_id) do
    Repo.update_all(
      from(r in Repository,
        where: r.id == ^repository.id,
        update: [set: [installation_id: ^installation_id, deleted_at: nil]]
      ),
      []
    )
  end

  defp get_repo_full_names(user) do
    case Users.get_user_github_data(user) do
      {:ok, %{repos: repos}} ->
        Enum.map(repos, fn repo -> repo.full_name end)

      _ ->
        []
    end
  end

  @doc """
  Returns either the owner/name of the repo
  or the title given to it
  """
  def get_title(repository) do
    if is_nil(repository.title) do
      "#{repository.name}"
    else
      repository.title
    end
  end

  def total_rewards_for_each_action(repository) do
    total_rewards_for_each_action =
      from(
        pledge in Incentivize.Pledge,
        join: fund in Incentivize.Fund,
        on: fund.id == pledge.fund_id,
        where: ^repository.id == fund.repository_id,
        group_by: pledge.action,
        select: %{
          action: pledge.action,
          sum: sum(pledge.amount)
        }
      )

    Repo.all(total_rewards_for_each_action)
  end
end
