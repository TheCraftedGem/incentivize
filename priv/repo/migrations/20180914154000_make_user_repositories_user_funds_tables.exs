defmodule Incentivize.Repo.Migrations.MakeUserRepositoriesUserFundsTables do
  use Ecto.Migration

  def change do
    create table(:user_repositories) do
      add(:repository_id, references(:repositories, on_delete: :nothing))
      add(:user_id, references(:users, on_delete: :nothing))
      timestamps()
    end

    create table(:user_funds) do
      add(:fund_id, references(:funds, on_delete: :nothing))
      add(:user_id, references(:users, on_delete: :nothing))
      timestamps()
    end

    create(index(:user_repositories, [:repository_id, :user_id]))
    create(index(:user_funds, [:fund_id, :user_id]))
  end
end
