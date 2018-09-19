defmodule Incentivize.Github.Installations do
  @moduledoc """
  Module for interacting with Installations
  """

  import Ecto.{Query}, warn: false
  alias Ecto.Multi
  alias Incentivize.{Github.Installation, Github.InstallationRepository, Repo}

  def create_installation(params) do
    %Installation{}
    |> Installation.changeset(params)
    |> Repo.insert()
  end

  def update_installation(installation, params) do
    installation
    |> Installation.changeset(params)
    |> Repo.update()
  end

  def delete_installation(installation) do
    Multi.new()
    |> Multi.delete_all(
      :installation_repositories,
      from(ir in InstallationRepository, where: ir.installation_id == ^installation.id)
    )
    |> Multi.delete(:installation, installation)
    |> Repo.transaction()
  end

  def get_installation_by_github_login(github_login) do
    Repo.get_by(Installation, github_login: github_login)
  end

  def get_installation_by_installation_id(installation_id) do
    Repo.get_by(Installation, installation_id: installation_id)
  end

  def get_installation(id) do
    Repo.get(Installation, id)
  end

  def delete_installation_repositories(installation, repositories) do
    repository_ids = Enum.map(repositories, fn repository -> repository.id end)

    Repo.delete_all(
      from(ir in InstallationRepository,
        where: ir.installation_id == ^installation.id and ir.repository_id in ^repository_ids
      )
    )
  end

  def create_installation_repository(params) do
    %InstallationRepository{}
    |> InstallationRepository.changeset(params)
    |> Repo.insert()
  end
end
