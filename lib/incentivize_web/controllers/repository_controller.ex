defmodule IncentivizeWeb.RepositoryController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Github.App, Repository, Repositories, Users}

  action_fallback(IncentivizeWeb.FallbackController)

  def index(conn, params) do
    search_params = Map.get(params, "search", %{})

    repositories =
      Repositories.list_repositories_for_user(conn.assigns.current_user, search_params)

    render(conn, "index.html", repositories: repositories)
  end

  def settings(conn, _params) do
    %{user: %{github_id: user_github_id}, organizations: organizations} =
      Users.get_user_github_data(conn.assigns.current_user)

    user_installation_info =
      case App.github_app_module().get_user_app_installation_by_github_login(
             conn.assigns.current_user.github_login
           ) do
        {:ok, installation} ->
          installation_id = installation["id"]
          repositories = Repositories.list_repositories_for_installation(installation_id)

          %{
            id: user_github_id,
            login: conn.assigns.current_user.github_login,
            installation_id: installation_id,
            repositories: repositories
          }

        _ ->
          %{
            id: user_github_id,
            login: conn.assigns.current_user.github_login,
            installation_id: nil,
            repositories: []
          }
      end

    organization_installation_info =
      organizations
      |> Enum.map(fn org ->
        case App.github_app_module().get_organization_app_installation_by_github_login(org.login) do
          {:ok, installation} ->
            installation_id = installation["id"]

            repositories = Repositories.list_repositories_for_installation(installation_id)

            %{
              id: org.id,
              login: org.login,
              installation_id: installation_id,
              repositories: repositories
            }

          _ ->
            %{id: org.id, login: org.login, installation_id: nil, repositories: []}
        end
      end)

    render(conn, "settings.html",
      user_installation_info: user_installation_info,
      organization_installation_info: organization_installation_info,
      github_app_url: App.github_app_module().public_url()
    )
  end

  def show(conn, %{"owner" => owner, "name" => name}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    if Repositories.can_view_repository?(repository, conn.assigns.current_user) do
      stats = Repositories.get_repository_stats(repository)

      render(conn, "show.html", repository: repository, stats: stats)
    else
      :not_found
    end
  end

  def edit(conn, %{"owner" => owner, "name" => name}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    if Repositories.can_edit_repository?(repository, conn.assigns.current_user) do
      changeset = Repository.update_changeset(repository)
      render(conn, "edit.html", repository: repository, changeset: changeset)
    else
      :not_found
    end
  end

  def update(conn, %{"owner" => owner, "name" => name}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    if Repositories.can_edit_repository?(repository, conn.assigns.current_user) do
      conn
      |> put_flash(:info, "#{Repositories.get_title(repository)} updated.")
      |> redirect(to: repository_path(conn, :edit, owner, name))
    else
      :not_found
    end
  end
end
