defmodule IncentivizeWeb.RepositoryController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Repositories, Repository}

  def new(conn, _params) do
    changeset = Repository.create_changeset(%Repository{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"repository" => repo_params}) do
    repo_params = Map.put(repo_params, "admin_id", conn.assigns.current_user.id)

    case Repositories.create_repository(repo_params) do
      {:ok, repository} ->
        conn
        |> put_flash(:info, "Created successfully.")
        |> redirect(to: repository_path(conn, :webhook, repository.owner, repository.name))

      {:error, changeset} ->
        conn
        |> put_status(400)
        |> put_flash(:error, "Failed to create.")
        |> render("new.html", changeset: changeset)
    end
  end

  def webhook(conn, %{"owner" => owner, "name" => name}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    if Repositories.user_owns_repository?(repository, conn.assigns.current_user) do
      render(conn, "webhook.html", repository: repository)
    else
      conn
      |> put_status(403)
      |> text("Unauthorized")
    end
  end
end
