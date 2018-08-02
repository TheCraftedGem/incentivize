defmodule Incentivize.Repositories.Test do
  use Incentivize.DataCase
  alias Incentivize.Repositories

  test "create" do
    user = insert!(:user)

    {:ok, repository} =
      Repositories.create_repository(%{
        "name" => "hi",
        "owner" => "owner",
        "admin_id" => user.id
      })

    assert repository.name == "hi"
    assert repository.webhook_secret != nil
  end

  test "update" do
    repo = insert!(:repository)

    {:ok, repository} =
      Repositories.update_repository(repo, %{
        "name" => "hi",
        "owner" => "owner"
      })

    assert repository.name == "hi"
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
