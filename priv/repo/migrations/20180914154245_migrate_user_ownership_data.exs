defmodule Incentivize.Repo.Migrations.MigrateUserOwnershipData do
  use Ecto.Migration

  def change do
    execute(
      """
      with ur as (select id, admin_id, inserted_at, updated_at from repositories)
      insert into user_repositories (repository_id, user_id, inserted_at, updated_at)
      select ur.id, ur.admin_id, ur.inserted_at, ur.updated_at from ur
      """,
      ""
    )

    execute(
      """
      with uf as (select id, supporter_id, inserted_at, updated_at from funds)
      insert into user_funds (fund_id, user_id, inserted_at, updated_at)
      select uf.id, uf.supporter_id, uf.inserted_at, uf.updated_at from uf
      """,
      ""
    )

    alter table(:repositories) do
      remove(:admin_id)
    end

    alter table(:funds) do
      remove(:supporter_id)
    end
  end
end
