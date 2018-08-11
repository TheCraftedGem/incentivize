defmodule Incentivize.Funds do
  @moduledoc """
  Module for interacting with Funds
  """

  import Ecto.{Query}, warn: false
  alias Incentivize.{Fund, Pledge, Repo, Repository, Actions}

  def create_fund(params) do
    %Fund{}
    |> Fund.create_changeset(params)
    |> Repo.insert()
  end

  def get_fund_for_repository(repository, id) do
    Fund
    |> preload([:pledges])
    |> Repo.get_by(repository_id: repository.id, id: id)
  end

  def list_funds_for_repository(repository) do
    Fund
    |> where([f], f.repository_id == ^repository.id)
    |> order_by([f], f.inserted_at)
    |> Repo.all()
  end

  @spec list_funds_for_repository_and_action(Repository.t(), binary()) :: [Fund.t()]
  def list_funds_for_repository_and_action(repository, action) do
    # possibly return a list of pledges preloaded with funds instead?

    query =
      from(fund in Fund,
        join: pledge in Pledge,
        on: pledge.fund_id == fund.id,
        join: repo in Repository,
        on: fund.repo_id == repo.id,
        where: fund.repo_id == ^repository.id,
        where: pledge.action == ^action,
        where: pledge.amount > 0,
        preload: [:pledges],
        select: fund
      )

    Repo.all(query)
  end
end
