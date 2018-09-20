defmodule Incentivize.Repo.Migrations.Installation do
  use Ecto.Migration

  def change do
    create table(:github_installations) do
      add(:installation_id, :integer)
      add(:login, :string)
      add(:login_type, :string)
      timestamps()
    end

    create(unique_index(:github_installations, [:installation_id]))
    create(index(:github_installations, [:login]))
    create(index(:github_installations, [:login_type]))

    alter table(:repositories) do
      add(:deleted_at, :utc_datetime)
      add(:installation_id, :integer)
    end

    create(index(:repositories, [:deleted_at]))
    create(index(:repositories, [:installation_id]))
  end
end
