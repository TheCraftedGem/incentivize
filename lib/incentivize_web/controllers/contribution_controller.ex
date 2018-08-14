defmodule IncentivizeWeb.ContributionController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Contributions, Funds, Repositories}

  def for_repository(conn, %{"owner" => owner, "name" => name}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)
    contributions = Contributions.list_contributions_for_repository(repository)

    render(conn, "for_repository.html",
      repository: repository,
      contributions: contributions
    )
  end

  def for_fund(conn, %{"owner" => owner, "name" => name, "id" => id}) do
    repository = Repositories.get_repository_by_owner_and_name(owner, name)
    fund = Funds.get_fund_for_repository(repository, id)
    contributions = Contributions.list_contributions_for_fund(fund)

    render(conn, "for_fund.html", repository: repository, fund: fund, contributions: contributions)
  end
end
