defmodule Incentivize.Repo.Migrations.RenameIsPublicToPublic do
  use Ecto.Migration

  def change do
    drop(index("repositories", [:is_public]))
    rename(table("repositories"), :is_public, to: :public)
    create(index(:repositories, [:public]))
  end
end
