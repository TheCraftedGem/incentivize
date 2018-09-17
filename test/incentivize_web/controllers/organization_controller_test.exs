defmodule IncentivizeWeb.OrganizationControllerTest do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true
  alias Incentivize.Organizations

  setup %{conn: conn} do
    user = insert!(:user)

    conn =
      conn
      |> assign(:current_user, user)

    [user: user, conn: conn]
  end

  test "GET /organizations/new", %{conn: conn} do
    conn = get(conn, organization_path(conn, :new))
    assert html_response(conn, 200) =~ "Create an Organization"
  end

  test "POST /organizations/create", %{conn: conn, user: _user} do
    conn = post(conn, organization_path(conn, :create), organization: [name: "hello"])

    assert redirected_to(conn) =~ organization_path(conn, :show, "hello")

    assert Organizations.get_organization_by_slug("hello") != nil
  end

  test "POST /organizations/create when name already taken", %{conn: conn, user: user} do
    insert!(:organization, created_by: user, name: "hello1")

    conn = post(conn, organization_path(conn, :create), organization: [name: "hello1"])

    assert html_response(conn, 400) =~ "taken"
  end

  test "GET /organizations/:slug", %{conn: conn} do
    organization = insert!(:organization)

    conn = get(conn, organization_path(conn, :show, organization.slug))
    assert html_response(conn, 200) =~ organization.name
  end

  test "GET /organizations/:slug when not found", %{conn: conn} do
    conn = get(conn, organization_path(conn, :show, "someorg"))
    assert html_response(conn, 404)
  end
end
