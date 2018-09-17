defmodule Incentivize.Repo.Migrations.CreatedBy do
  use Ecto.Migration

  def change do
    alter table(:funds) do
      add(:created_by_id, references(:users, on_delete: :nothing))
    end

    alter table(:repositories) do
      add(:created_by_id, references(:users, on_delete: :nothing))
    end

    create(index(:funds, [:created_by_id]))
    create(index(:repositories, [:created_by_id]))
  end
end
