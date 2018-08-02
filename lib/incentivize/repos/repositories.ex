defmodule Incentivize.Repositories do
  @moduledoc """
  Module for interacting with Repositories
  """

  import Ecto.{Query}, warn: false
  alias Incentivize.{Repo, Repository}

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
    Repo.get_by(Repository, owner: owner, name: name)
  end

  def get_repository(id) do
    Repo.get(Repository, id)
  end
end
