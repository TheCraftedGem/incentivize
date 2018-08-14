defmodule Incentivize.Github.WebhookHandler do
  @moduledoc """
  Handles processing of GitHub webhooks
  """
  alias Incentivize.{Actions, Contributions, Funds, Repositories, Users}
  @stellar_module Application.get_env(:incentivize, :stellar_module)
  @actions Map.keys(Actions.github_actions())
  @event_to_payload_map %{
    "issues" => "issue",
    "issue_comment" => "comment",
    "pull_request" => "pull_request"
  }

  @doc """
  Takes in GitHub event payload and process contributions

  Checks to see if action is incentivized and user exists.
  If so, then they are given the amount of lumens specified
  by the pledge for that action and repo. This checks for
  all pledges for the repo so may give more than one contribution
  if multiple pledges exist.
  """
  @spec handle(binary(), map()) :: {:ok, map()} | {:error, atom()}
  def handle(event_and_action, payload) when event_and_action in @actions do
    [event, _action] = String.split(event_and_action, ".")

    repository = payload["repository"]
    event_payload = payload[@event_to_payload_map[event]]
    user = event_payload["user"]

    [repo_owner, repo_name] = String.split(repository["full_name"], "/")

    repository = Repositories.get_repository_by_owner_and_name(repo_owner, repo_name)
    user = Users.get_user_by_github_login(user["login"])
    pledges = Funds.list_pledges_for_repository_and_action(repository, event_and_action)

    if can_reward_contribution?(repository, user, pledges) do
      results =
        Enum.reduce(
          pledges,
          %{
            errors: [],
            contributions: []
          },
          &add_contribution(&1, repository, user, event_and_action, event_payload, &2)
        )

      {:ok, results}
    else
      {:error, :unsupported_user_or_repository}
    end
  end

  def handle(_, _) do
    {:error, :invalid_action}
  end

  defp can_reward_contribution?(repository, user, pledges) do
    repository != nil && user != nil && Enum.empty?(pledges) == false
  end

  defp add_contribution(pledge, repository, user, action, event_payload, operations) do
    with {:ok, transaction_url} <-
           @stellar_module.reward_contribution(
             pledge.fund.stellar_public_key,
             user.stellar_public_key,
             pledge.amount,
             "incentivize"
           ),
         {:ok, contribution} <-
           Contributions.create_contribution(%{
             amount: pledge.amount,
             action: action,
             github_url: event_payload["html_url"],
             stellar_transaction_url: transaction_url,
             pledge_id: pledge.id,
             user_id: user.id,
             repository_id: repository.id
           }) do
      Map.put(operations, :contributions, operations.contributions ++ [contribution])
    else
      {:error, error} ->
        error = %{
          error: error,
          action: action,
          user_id: user.id,
          repository_id: repository.id,
          pledge_id: pledge.id,
          github_url: event_payload["html_url"]
        }

        Map.put(operations, :errors, operations.errors ++ [error])
    end
  end
end
