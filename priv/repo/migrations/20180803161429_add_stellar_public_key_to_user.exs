defmodule Incentivize.Repo.Migrations.AddStellarPublicKeyToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:stellar_public_key, :string)
    end

    create(index(:users, [:stellar_public_key]))
  end
end
