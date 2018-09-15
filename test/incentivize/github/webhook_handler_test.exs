defmodule Incentivize.Github.WebhookHandler.Test do
  use Incentivize.DataCase, async: true
  alias Incentivize.{Funds, Github.WebhookHandler}
  @stellar_module Application.get_env(:incentivize, :stellar_module)

  test "invalid action" do
    assert {:error, :unsupported} = WebhookHandler.handle("whatever", %{})
  end

  test "unsupported user" do
    insert!(:repository, owner: "Codertocat", name: "Hello-World")

    json =
      "./test/fixtures/issues_opened.json"
      |> File.read!()
      |> Poison.decode!()

    assert {:error, :ineligible} =
             WebhookHandler.handle(
               "issues.opened",
               json
             )
  end

  test "user exists but no pledges" do
    insert!(:repository, owner: "Codertocat", name: "Hello-World")
    insert!(:user, github_login: "Codertocat")

    json =
      "./test/fixtures/issues_opened.json"
      |> File.read!()
      |> Poison.decode!()

    assert {:error, :ineligible} =
             WebhookHandler.handle(
               "issues.opened",
               json
             )
  end

  test "fund has no XLM in it" do
    repository = insert!(:repository, owner: "Codertocat", name: "Hello-World")

    supporter =
      insert!(:user,
        github_login: "Codertocat",
        stellar_public_key: "GBDIIX7BVWB6WLYMHH22VBTC4DNVU4FURM75O374RAC4FYNN7H46VRSS"
      )

    {:ok, _fund} =
      Funds.create_fund(
        %{
          repository_id: repository.id,
          pledges: %{"0" => %{"action" => "issues.opened", "amount" => "1"}}
        },
        supporter
      )

    json =
      "./test/fixtures/issues_opened.json"
      |> File.read!()
      |> Poison.decode!()

    assert {:ok, :scheduled} =
             WebhookHandler.handle(
               "issues.opened",
               json
             )
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

    json =
      "./test/fixtures/issues_opened.json"
      |> File.read!()
      |> Poison.decode!()

    assert {:ok, :scheduled} =
             WebhookHandler.handle(
               "issues.opened",
               json
             )
  end

  test "PR closed but not merged" do
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
          pledges: %{"0" => %{"action" => "pull_request.closed", "amount" => "1"}}
        },
        supporter
      )

    {:ok, _transaction_url} =
      @stellar_module.add_funds_to_account(
        fund.stellar_public_key,
        Decimal.new(20),
        "Fund escrow"
      )

    json =
      "./test/fixtures/pull_request_closed.json"
      |> File.read!()
      |> Poison.decode!()

    assert {:error, :ineligible} =
             WebhookHandler.handle(
               "pull_request.closed",
               json
             )
  end

  test "PR merged" do
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
          pledges: %{"0" => %{"action" => "pull_request.closed", "amount" => "1"}}
        },
        supporter
      )

    {:ok, _transaction_url} =
      @stellar_module.add_funds_to_account(
        fund.stellar_public_key,
        Decimal.new(20),
        "Fund escrow"
      )

    json =
      "./test/fixtures/pull_request_merged.json"
      |> File.read!()
      |> Poison.decode!()

    assert {:ok, :scheduled} =
             WebhookHandler.handle(
               "pull_request.closed",
               json
             )
  end
end
