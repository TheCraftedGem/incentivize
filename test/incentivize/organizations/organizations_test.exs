defmodule Incentivize.Organizations.Test do
  use Incentivize.DataCase, async: true
  alias Incentivize.Organizations

  test "create" do
    user = insert!(:user)

    {:ok, organization} =
      Organizations.create_organization(%{
        "name" => "HelloWorld",
        "created_by_id" => user.id
      })

    assert organization.name == "HelloWorld"
    assert organization.created_by_id == user.id
  end

  test "create with existing name fails" do
    existing_organization = insert!(:organization)

    user = insert!(:user)

    assert {:error, _} =
             Organizations.create_organization(%{
               "name" => existing_organization.name,
               "created_by_id" => user.id
             })
  end

  test "create without name fails" do
    user = insert!(:user)

    assert {:error, _} =
             Organizations.create_organization(%{
               "created_by_id" => user.id
             })
  end

  test "update" do
    organization = insert!(:organization)

    {:ok, organization} =
      Organizations.update_organization(organization, %{
        "name" => "HelloWorld2"
      })

    assert organization.name == "HelloWorld2"
  end

  test "get_organization_by_slug" do
    organization = insert!(:organization)
    organization_from_db = Organizations.get_organization_by_slug(organization.slug)

    assert organization.id == organization_from_db.id
  end

  test "get_organization" do
    organization = insert!(:organization)
    organization_from_db = Organizations.get_organization(organization.id)

    assert organization.id == organization_from_db.id
  end

  test "list_organizations" do
    _organizations = [
      insert!(:organization),
      insert!(:organization),
      insert!(:organization)
    ]

    organizations_from_db = Organizations.list_organizations()

    assert length(organizations_from_db) == 3
  end

  test "list_organizations_for_user" do
    user = insert!(:user)

    _organizations = [
      insert!(:organization, created_by: user),
      insert!(:organization, created_by: user),
      insert!(:organization)
    ]

    organizations_from_db = Organizations.list_organizations_for_user(user)

    assert length(organizations_from_db) == 2
  end
end
