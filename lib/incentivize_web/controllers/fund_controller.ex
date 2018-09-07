defmodule IncentivizeWeb.FundController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Funds, Pledge, Repositories}

  def index(conn, %{"owner" => owner, "name" => name}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    funds = Funds.list_funds_for_repository(repository)

    render(conn, "index.html", repository: repository, funds: funds)
  end

  def new(conn, %{"owner" => owner, "name" => name}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    changeset = Fund.create_changeset(%Fund{})

    render(conn, "new.html", repository: repository, changeset: changeset)
  end

  def create(conn, %{"owner" => owner, "name" => name, "fund" => params}) do
    pledges = Map.get(params, "pledges", %{})

    pledges =
      pledges
      |> Enum.filter(fn {_index, %{"action" => _action, "amount" => amount}} ->
        if amount == "" or amount == "0" do
          false
        else
          true
        end
      end)
      |> Enum.into(%{})

    params = Map.put(params, "pledges", pledges)

    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    params =
      params
      |> Map.put("supporter_id", conn.assigns.current_user.id)
      |> Map.put("repository_id", repository.id)

    case Funds.create_fund(params) do
      {:ok, fund} ->
        conn
        |> put_flash(:info, "Created successfully.")
        |> redirect(to: fund_path(conn, :show, repository.owner, repository.name, fund.id))

      {:error, changeset} ->
        conn
        |> put_status(400)
        |> put_flash(:error, "Failed to create.")
        |> render("new.html", repository: repository, changeset: changeset)
    end
  end

  def show(conn, %{"owner" => owner, "name" => name, "id" => id}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    fund = Funds.get_fund_for_repository(repository, id)

    render(conn, "show.html", repository: repository, fund: fund)
  end
end
