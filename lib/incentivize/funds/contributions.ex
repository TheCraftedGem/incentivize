defmodule Incentivize.Contributions do
  @moduledoc """
  Module for interacting with Contributions
  """

  import Ecto.{Query}, warn: false
  alias Incentivize.{Contribution, Fund, Pledge, Repo}

  def create_contribution(params) do
    %Contribution{}
    |> Contribution.changeset(params)
    |> Repo.insert()
  end

  def list_contributions_for_user(user) do
    Contribution
    |> where([c], c.user_id == ^user.id)
    |> order_by([c], c.inserted_at)
    |> preload([:pledge, :repository])
    |> Repo.all()
  end

  def list_contributions_for_repository(repository) do
    Contribution
    |> where([c], c.repository_id == ^repository.id)
    |> order_by([c], c.inserted_at)
    |> preload([:pledge, :user])
    |> Repo.all()
  end

  def list_contributions_for_fund(fund) do
    query =
      from(c in Contribution,
        join: pledge in Pledge,
        on: c.pledge_id == pledge.id,
        join: fund in Fund,
        on: pledge.fund_id == fund.id,
        where: fund.id == ^fund.id,
        order_by: c.inserted_at,
        preload: [:pledge, :user],
        select: c
      )

    Repo.all(query)
  end
end
