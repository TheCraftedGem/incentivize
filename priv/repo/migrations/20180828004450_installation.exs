defmodule Incentivize.Repo.Migrations.Installation do
  use Ecto.Migration

  def change do
    create table(:github_installations) do
      add(:installation_id, :integer)
      add(:login, :string)
      add(:login_type, :string)
      timestamps()
    end

    create(index(:github_installations, [:installation_id]))
    create(index(:github_installations, [:login]))
    create(index(:github_installations, [:login_type]))

    alter table(:repositories) do
      add(:installation_id, references(:github_installations, on_delete: :nothing))
      add(:private, :boolean, default: false)
    end

    create(index(:repositories, [:installation_id]))
    create(index(:repositories, [:private]))
  end
end
