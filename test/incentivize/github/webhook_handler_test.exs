defmodule Incentivize.Github.WebhookHandler.Test do
  use Incentivize.DataCase
  alias Incentivize.Github.WebhookHandler

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
end
