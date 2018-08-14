defmodule Incentivize.Funds do
  @moduledoc """
  Module for interacting with Funds
  """

  import Ecto.{Query}, warn: false
  alias Incentivize.{Fund, Pledge, Repo, Repository}

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

  def list_funds_for_supporter(supporter) do
    Fund
    |> where([f], f.supporter_id == ^supporter.id)
    |> order_by([f], f.inserted_at)
    |> preload([:pledges, :repository])
    |> Repo.all()
  end

  def list_funds_for_repository(repository) do
    Fund
    |> where([f], f.repository_id == ^repository.id)
    |> order_by([f], f.inserted_at)
    |> preload([:pledges, :supporter])
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
end
