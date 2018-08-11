defmodule Incentivize.Repo.Migrations.Contribution do
  use Ecto.Migration

  def change do
    create table(:contributions) do
      add(:amount, :decimal)
      add(:action, :string)
      add(:github_url, :string)
      add(:stellar_transaction_url, :string)
      add(:pledge_id, references(:pledges, on_delete: :nothing))
      add(:repository_id, references(:repositories, on_delete: :nothing))
      add(:user_id, references(:users, on_delete: :nothing))
      timestamps()
    end

    create(index(:contributions, [:action]))
    create(index(:contributions, [:amount]))
    create(index(:contributions, [:pledge_id]))
    create(index(:contributions, [:repository_id]))
    create(index(:contributions, [:user_id]))
  end
end
