defmodule Incentivize.Github.WebhookHandler.Test do
  use Incentivize.DataCase, async: true
  alias Incentivize.Github.WebhookHandler
  alias Incentivize.{Funds}
  @stellar_module Application.get_env(:incentivize, :stellar_module)

  test "invalid action" do
    assert {:error, :invalid_action} = WebhookHandler.handle("whatever", %{})
  end

  test "unsupported user" do
    insert!(:repository, owner: "Codertocat", name: "Hello-World")

    json =
      "./test/fixtures/issues_opened.json"
      |> File.read!()
      |> Poison.decode!()

    assert {:error, :unsupported_user_or_repository} =
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

    assert {:error, :unsupported_user_or_repository} =
             WebhookHandler.handle(
               "issues.opened",
               json
             )
  end

  test "fund has no lumens in it" do
    repository = insert!(:repository, owner: "Codertocat", name: "Hello-World")

    supporter =
      insert!(:user,
        github_login: "Codertocat",
        stellar_public_key: "GBDIIX7BVWB6WLYMHH22VBTC4DNVU4FURM75O374RAC4FYNN7H46VRSS"
      )

    {:ok, _fund} =
      Funds.create_fund(%{
        repository_id: repository.id,
        supporter_id: supporter.id,
        pledges: %{"0" => %{"action" => "issues.opened", "amount" => "1"}}
      })

    json =
      "./test/fixtures/issues_opened.json"
      |> File.read!()
      |> Poison.decode!()

    {:ok, result} =
      WebhookHandler.handle(
        "issues.opened",
        json
      )

    assert Enum.empty?(result.errors) == false
  end

  test "fund has lumens in it" do
    repository = insert!(:repository, owner: "Codertocat", name: "Hello-World")

    supporter =
      insert!(:user,
        github_login: "Codertocat",
        stellar_public_key: "GBZY6AL6QU6TYSGUZ22LXNUR7BZNTCABEP7VOOVEHDANJDY4YULNBLW5"
      )

    {:ok, fund} =
      Funds.create_fund(%{
        repository_id: repository.id,
        supporter_id: supporter.id,
        pledges: %{"0" => %{"action" => "issues.opened", "amount" => "1"}}
      })

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

    {:ok, result} =
      WebhookHandler.handle(
        "issues.opened",
        json
      )

    assert Enum.empty?(result.contributions) == false
  end
end
