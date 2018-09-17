defmodule Incentivize.Repo.Migrations.UpgradeRihannaJobs do
  use Rihanna.Migration.Upgrade
  # This creates an index concurrently which cannot run in a transaction
  # so we disable them here
  @disable_ddl_transaction true
end
