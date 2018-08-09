defmodule Incentivize.Repo.Migrations.Funds do
  use Ecto.Migration

  def change do
    create table(:funds) do
      add(:pledge_amount, :decimal)
      add(:stellar_public_key, :string)
      add(:actions, {:array, :string}, null: false, default: [])
      add(:supporter_id, references(:users, on_delete: :nothing))
      add(:repository_id, references(:repositories, on_delete: :nothing))
      timestamps()
    end

    create(index(:funds, [:pledge_amount]))
    create(index(:funds, [:stellar_public_key]))
    create(index(:funds, [:actions]))
    create(index(:funds, [:supporter_id]))
    create(index(:funds, [:repository_id]))
    create(index(:funds, [:repository_id, :actions]))
    create(index(:funds, [:supporter_id, :actions]))
  end
end
