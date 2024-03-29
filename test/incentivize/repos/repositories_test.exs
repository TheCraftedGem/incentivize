defmodule Incentivize.Repositories.Test do
  use Incentivize.DataCase, async: true
  alias Incentivize.Repositories

  test "create" do
    user = insert!(:user)

    {:ok, repository} =
      Repositories.create_repository(%{
        "owner" => "octocat",
        "name" => "Hello-World",
        "created_by_id" => user.id,
        "public" => true,
        "installation_id" => 12_345
      })

    assert repository.name == "Hello-World"
  end

  test "update" do
    repo = insert!(:repository)

    {:ok, repository} =
      Repositories.update_repository(repo, %{
        "owner" => "octocat",
        "name" => "Hello-World",
        "public" => true,
        "installation_id" => 12_345
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
