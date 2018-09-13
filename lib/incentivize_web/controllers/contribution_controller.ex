defmodule IncentivizeWeb.ContributionController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Contributions, Funds, Repositories}
  action_fallback(IncentivizeWeb.FallbackController)

  def for_repository(conn, %{"owner" => owner, "name" => name}) do
    case Repositories.get_repository_by_owner_and_name(owner, name) do
      nil ->
        :not_found

      repository ->
        contributions = Contributions.list_contributions_for_repository(repository)

        render(conn, "for_repository.html",
          repository: repository,
          contributions: contributions
        )
    end
  end

  def for_fund(conn, %{"owner" => owner, "name" => name, "id" => id}) do
    with repository when not is_nil(repository) <-
           Repositories.get_repository_by_owner_and_name(owner, name),
         fund when not is_nil(fund) <- Funds.get_fund_for_repository(repository, id) do
      contributions = Contributions.list_contributions_for_fund(fund)

      render(conn, "for_fund.html",
        repository: repository,
        fund: fund,
        contributions: contributions
      )
    else
      _ ->
        :not_found
    end
  end
end
