defmodule IncentivizeWeb.AccountController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Contributions, EmailVerifications, Funds, Notifications, User, Users}

  def show(conn, _params) do
    user = conn.assigns.current_user
    funds = Funds.list_funds_for_supporter(user)
    contributions = Contributions.list_contributions_for_user(user)

    render(conn, "show.html",
      user: user,
      funds: funds,
      contributions: contributions
    )
  end

  def wallet(conn, _params) do
    user = conn.assigns.current_user
    funds = Funds.list_funds_for_supporter(user)
    contributions = Contributions.list_contributions_for_user(user)

    render(conn, "wallet.html",
      user: user,
      funds: funds,
      contributions: contributions
    )
    
  end

  def edit(conn, _params) do
    user = conn.assigns.current_user
    changeset = User.changeset(user)

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    case Users.update_user(conn.assigns.current_user, user_params) do
      {:ok, user} ->
        unless EmailVerifications.user_email_captured?(user, user.email) do
          EmailVerifications.create_new_email_verification(user, user.email)
          Notifications.send_email_verification_email(user)
        end

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

    case Users.get_user_github_data(conn.assigns.current_user) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Organizations Synced")
        |> redirect(to: repository_path(conn, :settings))

      {:error, _} ->
        conn
        |> put_flash(:error, "Unable to retrieve GitHub data")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def verify_email(conn, %{"token" => token}) do
    case EmailVerifications.verify_email_verification_token(token) do
      :error ->
        conn
        |> put_flash(:error, "Unable to verify email address")
        |> redirect(to: page_path(conn, :index))

      {:ok, user, email} ->
        {:ok, _} = EmailVerifications.verify_user_email(user, email)

        conn
        |> put_flash(:info, "Email verified")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def resend_email_verification(conn, _) do
    Notifications.send_email_verification_email(conn.assigns.current_user)

    conn
    |> put_flash(:info, "Verification email resent")
    |> redirect(to: account_path(conn, :show))
  end
end
