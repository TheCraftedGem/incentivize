defmodule IncentivizeWeb.OrganizationController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Organization, Organizations}
  action_fallback(IncentivizeWeb.FallbackController)

  def new(conn, _params) do
    changeset = Organization.changeset(%Organization{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"organization" => params}) do
    params = Map.put(params, "created_by_id", conn.assigns.current_user.id)

    case Organizations.create_organization(params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Created successfully.")
        |> redirect(to: organization_path(conn, :show, organization.slug))

      {:error, changeset} ->
        conn
        |> put_status(400)
        |> put_flash(:error, "Failed to create.")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug}) do
    case Organizations.get_organization_by_slug(slug) do
      nil ->
        :not_found

      organization ->
        render(conn, "show.html", organization: organization)
    end
  end
end
