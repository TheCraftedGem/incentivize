defmodule Incentivize.Github.Installations do
  @moduledoc """
  Module for interacting with Installations
  """

  import Ecto.{Query}, warn: false

  alias Incentivize.{
    Github.Installation,
    Repo,
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

  def delete_installation(installation_id) do
    Repo.transaction(fn ->
      installation = get_installation_by_installation_id(installation_id)

      if installation do
        # Delete repos associated with the installation
        Repositories.delete_repositories_for_installation_id(installation.id)

        # Delete installation
        Repo.delete(installation)
      end
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
end
