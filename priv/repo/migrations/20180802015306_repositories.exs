defmodule Incentivize.Repo.Migrations.Repositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add(:name, :string)
      add(:owner, :string)
      add(:webhook_secret, :string)
      add(:admin_id, references(:users, on_delete: :nothing))
      timestamps()
    end

    create(unique_index(:repositories, [:owner, :name]))
    create(unique_index(:repositories, [:webhook_secret]))
    create(index(:repositories, [:owner]))
    create(index(:repositories, [:admin_id]))
  end
end
