defmodule IncentivizeWeb.RepositoryView do
  use IncentivizeWeb, :view
  alias Incentivize.{Contributions}

  def count_contributions_for_repository(repo) do
    length(Contributions.list_contributions_for_repository(repo))
  end
end
