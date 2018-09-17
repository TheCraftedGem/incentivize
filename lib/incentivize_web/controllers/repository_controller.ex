defmodule IncentivizeWeb.RepositoryController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Repositories, Repository}
  action_fallback(IncentivizeWeb.FallbackController)

  def index(conn, _params) do
    repositories = Repositories.list_repositories()

    render(conn, "index.html", repositories: repositories)
  end

  def new(conn, _params) do
    case get_list_of_filtered_repos(conn.assigns.current_user) do
      {:ok, repos} ->
        changeset = Repository.create_changeset(%Repository{})
        render(conn, "new.html", changeset: changeset, repos: repos)

      {:error, _} ->
        conn
        |> put_flash(:error, "Unable to retrieve your public repositories")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def create(conn, %{"repository" => %{"repo_name" => repo_name}}) do
    [repo_owner, repo_name] = String.split(repo_name, "/")

    repo_params = %{
      "owner" => repo_owner,
      "name" => repo_name,
      "created_by_id" => conn.assigns.current_user.id
    }

    case Repositories.create_repository(repo_params) do
      {:ok, %{repository: repository}} ->
        conn
        |> put_flash(:info, "Created successfully.")
        |> redirect(to: repository_path(conn, :webhook, repository.owner, repository.name))

      {:error, :repository, changeset, _} ->
        {:ok, repos} = get_list_of_filtered_repos(conn.assigns.current_user)

        conn
        |> put_status(400)
        |> put_flash(:error, "Failed to create.")
        |> render("new.html", changeset: changeset, repos: repos)
    end
  end

  def show(conn, %{"owner" => owner, "name" => name}) do
    case Repositories.get_repository_by_owner_and_name(owner, name) do
      nil ->
        :not_found

      repository ->
        render(conn, "show.html", repository: repository)
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

  defp get_list_of_filtered_repos(user) do
    with {:ok, public_repos} <- github_repos_module().get_all_public_repos(user),
         repositories <- Repositories.list_repositories() do
      repositories_full_names =
        Enum.map(repositories, fn repo -> "#{repo.owner}/#{repo.name}" end)

      full_names =
        public_repos
        |> Enum.map(fn repo -> repo["full_name"] end)
        |> Enum.reject(fn full_name -> full_name in repositories_full_names end)

      {:ok, full_names}
    else
      {:error, _} = error ->
        error

      _ ->
        {:error, "unspecified error"}
    end
  end

  defp github_repos_module do
    Application.get_env(:incentivize, :github_repos_module, Incentivize.Github.API.Repos)
  end
end
