defmodule IncentivizeWeb.AccountController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Contributions, Funds, Repositories, User, Users}

  def show(conn, _params) do
    user = conn.assigns.current_user
    funds = Funds.list_funds_for_supporter(user)
    contributions = Contributions.list_contributions_for_user(user)
    repositories = Repositories.list_repositories_for_user(user)

    render(conn, "show.html",
      user: user,
      funds: funds,
      contributions: contributions,
      repositories: repositories
    )
  end

  def wallet(conn, _params) do
    user = conn.assigns.current_user
    render(conn, "wallet.html", user: user)
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

  def sync(conn, _params) do
    Users.clear_user_github_data(conn.assigns.current_user)
    Users.get_user_github_data(conn.assigns.current_user)

    conn
    |> put_flash(:info, "GitHub Data Synced")
    |> redirect(to: account_path(conn, :show))
  end
end
