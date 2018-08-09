defmodule Incentivize.Funds do
  @moduledoc """
  Module for interacting with Funds
  """

  import Ecto.{Query}, warn: false
  alias Incentivize.{Fund, Repo}

  def create_fund(params) do
    %Fund{}
    |> Fund.create_changeset(params)
    |> Repo.insert()
  end

  def get_fund_for_repository(repository, id) do
    Repo.get_by(Fund, repository_id: repository.id, id: id)
  end
end
