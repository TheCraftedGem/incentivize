defmodule Incentivize.Github.WebhookHandler.Test do
  use Incentivize.DataCase
  alias Incentivize.Github.WebhookHandler
  alias Incentivize.Funds

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
        stellar_public_key: "GBZY6AL6QU6TYSGUZ22LXNUR7BZNTCABEP7VOOVEHDANJDY4YULNBLW5"
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
end
