defmodule Incentivize.Repo.Migrations.AddNameAndDescriptionToFunds do
  use Ecto.Migration

  def change do
    alter table(:funds) do
      add(:name, :string)
      add(:description, :text)
    end

    create(unique_index(:funds, ["lower(name)", :repository_id]))
  end
end
