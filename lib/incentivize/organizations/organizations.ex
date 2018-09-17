defmodule Incentivize.Organizations do
  @moduledoc """
  Module for interacting with Organizations
  """

  import Ecto.{Query}, warn: false
  alias Incentivize.{Organization, Repo, User}

  def list_organizations do
    Organization
    |> order_by([org], asc: org.name)
    |> Repo.all()
  end

  def list_organizations_for_user(user) do
    Organization
    |> join(
      :inner,
      [org],
      u in User,
      org.created_by_id == u.id and u.id == ^user.id
    )
    |> order_by([org], asc: org.name)
    |> Repo.all()
  end

  def create_organization(params) do
    Organization
    |> Organization.changeset(params)
    |> Repo.insert()
  end

  def update_organization(organization, params) do
    organization
    |> Organization.changeset(params)
    |> Repo.update()
  end

  def get_organization_by_slug(slug) do
    Repo.get_by!(Organization, slug: slug)
  end

  def get_organization(id) do
    Organization
    |> Repo.get(id)
  end
end
