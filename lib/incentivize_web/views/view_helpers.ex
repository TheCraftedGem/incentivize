defmodule IncentivizeWeb.ViewHelpers do
  @moduledoc """
  Site-wide view functions
  """
  alias Incentivize.{Repositories, User}

  @spec logged_in?(Plug.Conn.t()) :: boolean()
  def logged_in?(conn) do
    case conn.assigns.current_user do
      nil -> false
      %User{} -> true
    end
  end

  @doc """
  Title for page and also for open graph and twitter cards
  """
  def title(IncentivizeWeb.RepositoryView, "index.html", _assigns) do
    with_brand_name("Discover")
  end

  def title(IncentivizeWeb.RepositoryView, "show.html", %{repository: repository}) do
    with_brand_name(Repositories.get_title(repository))
  end

  def title(IncentivizeWeb.RepositoryView, "settings.html", _assigns) do
    with_brand_name("Connect Repositories")
  end

  def title(IncentivizeWeb.AccountView, "show.html", _assigns) do
    with_brand_name("Account Info")
  end

  def title(IncentivizeWeb.AccountView, "edit.html", _assigns) do
    with_brand_name("Edit Account")
  end

  def title(IncentivizeWeb.AccountView, "wallet.html", _assigns) do
    with_brand_name("Wallet")
  end

  def title(IncentivizeWeb.FundView, "index.html", %{repository: repository}) do
    with_brand_name("#{Repositories.get_title(repository)}'s Funds")
  end

  def title(IncentivizeWeb.FundView, "show.html", %{fund: fund}) do
    fund_name = IncentivizeWeb.FundView.fund_name(fund)

    with_brand_name("#{fund_name}")
  end

  def title(_view, _template, _assigns) do
    "Incentivize"
  end

  def description(IncentivizeWeb.FundView, "show.html", %{fund: fund}) do
    if fund.description do
      fund.description
    else
      description(nil, nil, nil)
    end
  end

  def description(_view, _template, _assigns) do
    "Incentivize.io is an incentive platform for software development that enables organizations or individuals to distribute Stellar Lumens to GitHub project contributors."
  end

  defp with_brand_name(title) do
    "#{title} | Incentivize"
  end
end
