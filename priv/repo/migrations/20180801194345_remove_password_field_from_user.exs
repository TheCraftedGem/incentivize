defmodule Incentivize.Repo.Migrations.RemovePasswordFieldFromUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove(:password)
      add(:github_login, :string)
      add(:github_access_token, :string)
      add(:github_avatar_url, :string)
    end

    create(unique_index(:users, [:github_login]))
    create(index(:users, [:github_access_token]))
  end
end
