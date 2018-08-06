defmodule IncentivizeWeb.AccountController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Users, User}

  def edit(conn, _params) do
    changeset = User.changeset(conn.assigns.current_user)

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    case Users.update_user(conn.assigns.current_user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Updated successfully.")
        |> redirect(to: account_path(conn, :edit))

      {:error, _} ->
        changeset = User.changeset(conn.assigns.current_user)

        conn
        |> put_status(400)
        |> put_flash(:error, "Failed to update.")
        |> render("edit.html", changeset: changeset)
    end
  end
end
