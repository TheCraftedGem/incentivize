defmodule Incentivize.Repo.Migrations.AddFieldsToRepositories do
  use Ecto.Migration

  def change do
    alter table(:repositories) do
      add(:title, :string)
      add(:description, :text)
      add(:logo_url, :string)
    end

    create table(:repository_links) do
      add(:repository_id, references(:repositories, on_delete: :nothing))
      add(:title, :string)
      add(:url, :string)
      timestamps()
    end

    create(index(:repository_links, [:repository_id]))
  end
end
