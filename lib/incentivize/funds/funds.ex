defmodule Incentivize.Funds do
  @moduledoc """
  Module for interacting with Funds
  """

  import Ecto.{Query}, warn: false
  alias Ecto.Multi
  alias Incentivize.{Fund, Pledge, Repo, Repository, Repositories, Users}
  @stellar_module Application.get_env(:incentivize, :stellar_module)

  def create_fund(params) do
    timeout = 120_000

    Multi.new()
    |> Multi.insert(:fund, Fund.create_changeset(%Fund{}, params))
    |> Multi.run(:create_stellar_fund, fn %{fund: fund} ->
      user = Users.get_user(fund.created_by_id)
      @stellar_module.create_fund_account(user.stellar_public_key)
    end)
    |> Multi.run(:update_fund, fn %{fund: fund, create_stellar_fund: escrow_public_key} ->
      fund
      |> Fund.add_stellar_public_key_changeset(%{stellar_public_key: escrow_public_key})
      |> Repo.update()
    end)
    |> Repo.transaction(timeout: timeout, pool_timeout: timeout)
  end

  def get_fund_for_repository(repository, id) do
    Fund
    |> preload([:pledges])
    |> Repo.get_by(repository_id: repository.id, id: id)
  end

  def list_funds_for_supporter(supporter) do
    Fund
    |> where([f], f.created_by_id == ^supporter.id)
    |> order_by([f], f.inserted_at)
    |> preload([:pledges, :created_by, :repository])
    |> Repo.all()
  end

  def list_funds_for_repository(repository) do
    Fund
    |> where([f], f.repository_id == ^repository.id)
    |> order_by([f], f.inserted_at)
    |> preload([:pledges, :created_by])
    |> Repo.all()
  end

  @spec list_pledges_for_repository_and_action(Repository.t(), binary()) :: [Pledge.t()]
  def list_pledges_for_repository_and_action(repository, action) do
    query =
      from(pledge in Pledge,
        join: fund in Fund,
        on: pledge.fund_id == fund.id,
        join: repo in Repository,
        on: fund.repository_id == repo.id,
        where: fund.repository_id == ^repository.id,
        where: pledge.action == ^action,
        where: pledge.amount > 0,
        preload: [:fund],
        select: pledge
      )

    Repo.all(query)
  end

  def get_pledge(pledge_id) do
    Pledge
    |> preload([:fund])
    |> Repo.get(pledge_id)
  end

  def get_fund(fund_id) do
    Fund
    |> preload([:pledges, :created_by])
    |> Repo.get(fund_id)
  end

  def can_view_fund?(fund, nil) do
    repository = Repositories.get_repository(fund.repository_id)
    Repositories.can_view_repository?(repository, nil)
  end

  def can_view_fund?(fund, user) do
    repository = Repositories.get_repository(fund.repository_id)
    can_view_repo? = Repositories.can_view_repository?(repository, user)

    can_view_repo? || fund.created_by_id == user.id
  end

  def can_edit_fund?(fund, user) do
    fund.created_by_id == user.id
  end
end
