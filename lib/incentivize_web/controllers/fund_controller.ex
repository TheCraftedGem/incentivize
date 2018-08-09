defmodule IncentivizeWeb.FundController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Funds, Fund}

  def new(conn, %{"owner" => owner, "name" => name}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    changeset = Fund.create_changeset(%Fund{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"owner" => owner, "name" => name, "fund" => params}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    params =
      params
      |> Map.put("user_id", conn.assigns.current_user.id)
      |> Map.put("repo_id", repository.id)

    case Funds.create_fund(repo_params) do
      {:ok, fund} ->
        conn
        |> put_flash(:info, "Created successfully.")
        |> redirect(to: fund_path(conn, :show, repository.owner, repository.name, fund.id))

      {:error, changeset} ->
        conn
        |> put_status(400)
        |> put_flash(:error, "Failed to create.")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"owner" => owner, "name" => name, "fund_id" => id}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    fund = Repositories.get_fund_for_repository(repository, id)

    render(conn, "show.html", fund: fund)
  end
end