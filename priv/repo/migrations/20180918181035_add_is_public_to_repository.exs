defmodule Incentivize.Repo.Migrations.AddIsPublicToRepository do
  use Ecto.Migration

  def change do
    alter table(:repositories) do
      add(:is_public, :boolean, default: true)
    end

    create(index(:repositories, [:is_public]))
  end
end
