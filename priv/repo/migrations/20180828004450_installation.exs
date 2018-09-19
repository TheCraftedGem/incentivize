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

    create table(:github_installation_repositories) do
      add(:installation_id, references(:github_installations, on_delete: :nothing))
      add(:repository_id, references(:repositories, on_delete: :nothing))
      timestamps()
    end

    create(unique_index(:github_installation_repositories, [:installation_id, :repository_id]))
    create(index(:github_installation_repositories, [:installation_id]))
    create(index(:github_installation_repositories, [:repository_id]))
  end
end
