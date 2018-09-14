defmodule Incentivize.Github.ContributionWorker.Test do
  use Incentivize.DataCase, async: true
  alias Incentivize.{Funds, Github.ContributionWorker}
  @stellar_module Application.get_env(:incentivize, :stellar_module)

  test "fund has no XLM in it" do
    repository = insert!(:repository, owner: "Codertocat", name: "Hello-World")

    supporter =
      insert!(:user,
        github_login: "Codertocat",
        stellar_public_key: "GBDIIX7BVWB6WLYMHH22VBTC4DNVU4FURM75O374RAC4FYNN7H46VRSS"
      )

    {:ok, %{fund: fund}} =
      Funds.create_fund(
        %{
          repository_id: repository.id,
          pledges: %{"0" => %{"action" => "issues.opened", "amount" => "1"}},
          supporter_stellar_public_key: supporter.stellar_public_key
        },
        supporter
      )

    fund = Funds.get_fund(fund.id)
    pledge = hd(fund.pledges)

    assert {:error, :failed} =
             ContributionWorker.perform([
               pledge.id,
               repository.id,
               supporter.id,
               "issues.opened",
               "https://github.com/Codertocat/Hello-World/issues/2"
             ])
  end

  test "fund has XLM in it" do
    repository = insert!(:repository, owner: "Codertocat", name: "Hello-World")

    supporter =
      insert!(:user,
        github_login: "Codertocat",
        stellar_public_key: "GBZY6AL6QU6TYSGUZ22LXNUR7BZNTCABEP7VOOVEHDANJDY4YULNBLW5"
      )

    {:ok, %{fund: fund}} =
      Funds.create_fund(
        %{
          repository_id: repository.id,
          supporter_stellar_public_key: supporter.stellar_public_key,
          pledges: %{"0" => %{"action" => "issues.opened", "amount" => "1"}}
        },
        supporter
      )

    {:ok, _transaction_url} =
      @stellar_module.add_funds_to_account(
        fund.stellar_public_key,
        Decimal.new(20),
        "Fund escrow"
      )

    fund = Funds.get_fund(fund.id)
    pledge = hd(fund.pledges)

    assert :ok =
             ContributionWorker.perform([
               pledge.id,
               repository.id,
               supporter.id,
               "issues.opened",
               "https://github.com/Codertocat/Hello-World/issues/2"
             ])
  end
end
