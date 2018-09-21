defmodule Incentivize.Repo.Migrations.RemoveUserFundsUserRepositories do
  use Ecto.Migration

  def change do
    drop(index(:user_repositories, [:repository_id, :user_id]))
    drop(index(:user_funds, [:fund_id, :user_id]))

    drop(table(:user_repositories))
    drop(table(:user_funds))
  end
end
