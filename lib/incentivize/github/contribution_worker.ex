defmodule Incentivize.Github.ContributionWorker do
  @behaviour Rihanna.Job
  alias Incentivize.{Contributions, Funds, Repositories, Users}
  @stellar_module Application.get_env(:incentivize, :stellar_module)

  @moduledoc """
  Handles creating contributions
  """

  def perform([
        pledge_id,
        repository_id,
        user_id,
        action,
        github_html_url
      ]) do
    pledge = Funds.get_pledge(pledge_id)
    repository = Repositories.get_repository(repository_id)
    user = Users.get_user(user_id)

    if pledge && repository && user do
      with {:ok, transaction_url} <-
             @stellar_module.reward_contribution(
               pledge.fund.stellar_public_key,
               user.stellar_public_key,
               pledge.amount,
               "incentivize"
             ),
           {:ok, _contribution} <-
             Contributions.create_contribution(%{
               amount: pledge.amount,
               action: action,
               github_url: github_html_url,
               stellar_transaction_url: transaction_url,
               pledge_id: pledge.id,
               user_id: user.id,
               repository_id: repository.id
             }) do
        :ok
      else
        {:error, _error} ->
          {:error, :failed}
      end
    else
      {:error, :failed}
    end
  end
end
