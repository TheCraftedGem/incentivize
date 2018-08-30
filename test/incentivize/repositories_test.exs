defmodule Incentivize.Repositories.Test do
  use Incentivize.DataCase, async: true
  alias Incentivize.Repositories

  test "create" do
    user = insert!(:user)

    {:ok, repository} =
      Repositories.create_repository(%{
        "owner" => "octocat",
        "name" => "Hello-World",
        "admin_id" => user.id
      })

    assert repository.name == "Hello-World"
    assert repository.webhook_secret != nil
  end

  test "create does not allow private repos" do
    user = insert!(:user)

    assert {:error, _} =
             Repositories.create_repository(%{
               "owner" => "hi",
               "name" => "hi",
               "admin_id" => user.id
             })
  end

  test "update" do
    repo = insert!(:repository)

    {:ok, repository} =
      Repositories.update_repository(repo, %{
        "owner" => "octocat",
        "name" => "Hello-World"
      })

    assert repository.name == "Hello-World"
  end

  test "get_repository_by_owner_and_name" do
    repo = insert!(:repository)
    repo_from_db = Repositories.get_repository_by_owner_and_name(repo.owner, repo.name)

    assert repo.id == repo_from_db.id
  end

  test "get_repository" do
    repo = insert!(:repository)
    repo_from_db = Repositories.get_repository(repo.id)

    assert repo.id == repo_from_db.id
  end
end
