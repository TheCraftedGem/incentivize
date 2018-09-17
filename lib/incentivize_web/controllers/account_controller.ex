defmodule IncentivizeWeb.AccountController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Contributions, Funds, Organizations, Repositories, User, Users}

  def show(conn, _params) do
    user = conn.assigns.current_user
    changeset = User.changeset(user)
    funds = Funds.list_funds_for_supporter(user)
    contributions = Contributions.list_contributions_for_user(user)
    repositories = Repositories.list_repositories_for_user(user)
    organizations = Organizations.list_organizations_for_user(user)

    render(conn, "show.html",
      changeset: changeset,
      user: user,
      funds: funds,
      contributions: contributions,
      repositories: repositories,
      organizations: organizations
    )
  end

  def edit(conn, _params) do
    user = conn.assigns.current_user
    changeset = User.changeset(user)

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    case Users.update_user(conn.assigns.current_user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Updated successfully.")
        |> redirect(to: account_path(conn, :show))

      {:error, _} ->
        changeset = User.changeset(conn.assigns.current_user)

        conn
        |> put_status(400)
        |> put_flash(:error, "Failed to update.")
        |> render("edit.html", changeset: changeset)
    end
  end
end
