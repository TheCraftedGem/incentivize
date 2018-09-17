defmodule Incentivize.Repo.Migrations.CreatedByDataMigrate do
  use Ecto.Migration

  def change do
    execute(
      """
      UPDATE
        funds
      SET
          created_by_id = user_funds.user_id
      FROM
          user_funds
      WHERE
          funds.id = user_funds.fund_id;
      """,
      ""
    )

    execute(
      """
      UPDATE
        repositories
      SET
          created_by_id = user_repositories.user_id
      FROM
          user_repositories
      WHERE
        repositories.id = user_repositories.repository_id;
      """,
      ""
    )
  end
end
