defmodule IncentivizeWeb.FundController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Fund, Funds, Repositories}

  action_fallback(IncentivizeWeb.FallbackController)

  def index(conn, %{"owner" => owner, "name" => name}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    if repository != nil and
         Repositories.can_view_repository?(repository, conn.assigns.current_user) do
      funds = Funds.list_funds_for_repository(repository)

      render(conn, "index.html", repository: repository, funds: funds)
    else
      :not_found
    end
  end

  def new(conn, %{"owner" => owner, "name" => name}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    if repository != nil and
         Repositories.can_view_repository?(repository, conn.assigns.current_user) do
      changeset = Fund.create_changeset(%Fund{})
      render(conn, "new.html", repository: repository, changeset: changeset)
    else
      :not_found
    end
  end

  def create(conn, %{"owner" => owner, "name" => name, "fund" => params}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)

    if repository != nil and
         Repositories.can_view_repository?(repository, conn.assigns.current_user) do
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

      params =
        params
        |> Map.put("repository_id", repository.id)
        |> Map.put("created_by_id", conn.assigns.current_user.id)

      case Funds.create_fund(params) do
        {:ok, %{fund: fund}} ->
          conn
          |> put_flash(:info, "Created successfully.")
          |> redirect(to: fund_path(conn, :show, repository.owner, repository.name, fund.id))

        {:error, :fund, changeset, _} ->
          conn
          |> put_status(400)
          |> put_flash(:error, "Failed to create.")
          |> render("new.html", repository: repository, changeset: changeset)
      end
    else
      :not_found
    end
  end

  def show(conn, %{"owner" => owner, "name" => name, "id" => id}) do
    with repository when not is_nil(repository) <-
           Repositories.get_repository_by_owner_and_name(owner, name),
         fund when not is_nil(fund) <- Funds.get_fund_for_repository(repository, id),
         true <- Funds.can_view_fund?(fund, conn.assigns.current_user) do
      render(conn, "show.html", repository: repository, fund: fund)
    else
      _ ->
        :not_found
    end
  end
end
