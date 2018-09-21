defmodule Incentivize.Repo.Migrations.OwnerNameIndex do
  use Ecto.Migration

  def change do
    create(index(:repositories, ["(owner || '/' || name)"]))
  end
end
