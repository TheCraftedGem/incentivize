defmodule Incentivize.Github.Installations do
  @moduledoc """
  Module for interacting with Installations
  """

  import Ecto.{Query}, warn: false

  alias Incentivize.{
    Github.Installation,
    Github.InstallationRepository,
    Repo,
    Repository,
    Repositories
  }

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
    Repo.transaction(fn ->
      # Get Repositories connected with installation
      # We use this to check if we need to delete any later on
      repositories =
        Repo.all(
          from(
            repository in Repository,
            join: ir in InstallationRepository,
            on:
              ir.repository_id == repository.id and
                ir.installation_id == ^installation.installation_id,
            select: repository
          )
        )

      # Delete installation repository associations
      Repo.delete_all(
        from(ir in InstallationRepository,
          where: ir.installation_id == ^installation.installation_id
        )
      )

      # Delete installation
      Repo.delete(installation)

      # Delete any repositories that do not have any more installations
      Enum.each(repositories, fn repository ->
        if count_installation_repositories_for_repository(repository.id) == 0 do
          Repositories.delete_repository(repository)
        end
      end)
    end)
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
    Repo.transaction(fn ->
      repository_ids = Enum.map(repositories, fn repository -> repository.id end)

      Repo.delete_all(
        from(ir in InstallationRepository,
          where:
            ir.installation_id == ^installation.installation_id and
              ir.repository_id in ^repository_ids
        )
      )

      Enum.each(repositories, fn repository ->
        if count_installation_repositories_for_repository(repository.id) == 0 do
          Repositories.delete_repository(repository)
        end
      end)
    end)
  end

  def create_installation_repository(params) do
    %InstallationRepository{}
    |> InstallationRepository.changeset(params)
    |> Repo.insert()
  end

  def get_installation_repository(installation_id, repository_id) do
    Repo.get_by(InstallationRepository,
      installation_id: installation_id,
      repository_id: repository_id
    )
  end

  def count_installation_repositories_for_repository(repository_id) do
    Repo.one(
      from(ir in InstallationRepository,
        where: ir.repository_id == ^repository_id,
        select: count(ir.id)
      )
    ) || 0
  end
end
