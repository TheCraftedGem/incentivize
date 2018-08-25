defmodule Incentivize.Installations do
  @moduledoc """
  Module for interacting with Installations
  """

  import Ecto.{Query}, warn: false
  alias Incentivize.{Installation, Repo}

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
