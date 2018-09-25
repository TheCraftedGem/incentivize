defmodule Incentivize.Repo.Migrations.RemoveRepositoryWebhooks do
  use Ecto.Migration

  def change do
    drop(unique_index(:repositories, [:webhook_secret]))

    alter table(:repositories) do
      remove(:webhook_secret)
    end
  end
end
