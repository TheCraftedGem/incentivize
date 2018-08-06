defmodule Incentivize.Repo.Migrations.AddUserTimestamps do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:logged_in_at, :utc_datetime)
    end

    create(index(:users, [:logged_in_at]))
  end
end
