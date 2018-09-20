defmodule IncentivizeWeb.RepositoryController do
  use IncentivizeWeb, :controller

  alias Incentivize.{
    Github.App,
    Repositories,
    Github.API.Organizations,
    Github.API.Users
  }

  action_fallback(IncentivizeWeb.FallbackController)

  def index(conn, _params) do
    repositories = Repositories.list_repositories()

    render(conn, "index.html", repositories: repositories)
  end

  def new(conn, _params) do
    {:ok, organizations} = Organizations.list_organizations_for_user(conn.assigns.current_user)
    {:ok, user} = Users.get_user(conn.assigns.current_user)

    user_installation_info =
      case App.get_user_app_installation_by_github_login(conn.assigns.current_user.github_login) do
        {:ok, installation} ->
          %{id: user["id"], login: user["login"], installation_id: installation["id"]}

        _ ->
          %{id: user["id"], login: user["login"], installation_id: nil}
      end

    organization_installation_info =
      Enum.map(organizations, fn org ->
        case App.get_organization_app_installation_by_github_login(org["login"]) do
          {:ok, installation} ->
            %{id: org["id"], login: org["login"], installation_id: installation["id"]}

          _ ->
            %{id: org["id"], login: org["login"], installation_id: nil}
        end
      end)
      |> Enum.sort(fn x, y -> String.downcase(x.login) < String.downcase(y.login) end)

    render(conn, "new.html",
      user_installation_info: user_installation_info,
      organization_installation_info: organization_installation_info,
      github_app_url: App.public_url()
    )
  end

  def show(conn, %{"owner" => owner, "name" => name}) do
    case Repositories.get_public_repository_by_owner_and_name(owner, name) do
      nil ->
        :not_found

      repository ->
        stats = Repositories.get_repository_stats(repository)

        render(conn, "show.html", repository: repository, stats: stats)
    end
  end
end
