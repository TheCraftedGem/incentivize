defmodule Incentivize.Repo.Migrations.Organizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add(:name, :string)
      add(:slug, :string)
      add(:created_by_id, references(:users, on_delete: :nothing))
      timestamps()
    end

    create(unique_index(:organizations, ["lower(name)"]))
    create(unique_index(:organizations, :slug))
    create(index(:organizations, :created_by_id))
  end
end
