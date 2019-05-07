defmodule Incentivize.Repo.Migrations.EmailSchemaUpdates do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:email_verified, :boolean, default: false)
    end

    create table(:email_verifications) do
      add(:user_id, references(:users, on_delete: :nothing))
      add(:email, :string)
      add(:verified_at, :utc_datetime)
      timestamps()
    end

    create(unique_index(:email_verifications, [:user_id, :email]))
  end
end
