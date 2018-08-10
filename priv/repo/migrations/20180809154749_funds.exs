defmodule Incentivize.Repo.Migrations.Funds do
  use Ecto.Migration

  def change do
    create table(:funds) do
      add(:stellar_public_key, :string)
      add(:supporter_id, references(:users, on_delete: :nothing))
      add(:repository_id, references(:repositories, on_delete: :nothing))
      timestamps()
    end

    create table(:pledges) do
      add(:amount, :decimal)
      add(:action, :string)
      add(:fund_id, references(:funds, on_delete: :nothing))
      timestamps()
    end

    create(index(:pledges, [:amount]))
    create(index(:pledges, [:fund_id]))
    create(unique_index(:pledges, [:fund_id, :action]))

    create(index(:funds, [:stellar_public_key]))
    create(index(:funds, [:supporter_id]))
    create(index(:funds, [:repository_id]))
  end
end
