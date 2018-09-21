defmodule Incentivize.Installations.Test do
  use Incentivize.DataCase, async: true
  alias Incentivize.{Github.Installations, Repositories}

  test "create" do
    {:ok, installation} =
      Installations.create_installation(%{
        "login" => "octocat",
        "login_type" => "User",
        "installation_id" => 12_345
      })

    assert installation.login == "octocat"
    assert installation.installation_id == 12_345
  end

  test "delete_installation" do
    assert {:ok, nil} = Installations.delete_installation(0)

    installation = insert!(:installation)
    repository = insert!(:repository, installation_id: installation.installation_id)
    Installations.delete_installation(installation.installation_id)

    assert Installations.get_installation_by_installation_id(installation.installation_id) == nil
    assert Repositories.get_repository(repository.id).deleted_at != nil
  end
end
