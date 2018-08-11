defmodule Incentivize.Github.WebhookHandler do
  @moduledoc """
  Handles processing of GitHub webhooks
  """
  alias Incentivize.{Actions, Contributions, Funds, Repositories, Stellar, Users}
  @actions Map.keys(Actions.github_actions())
  @event_to_payload_map %{
    "issues" => "issue",
    "issue_comment" => "comment",
    "pull_request" => "pull_request"
  }

  @spec handle(binary(), map()) :: {:ok, [Contribution.t()]} | {:error, atom()}
  def handle(event_and_action, payload) when event_and_action in @actions do
    [event, _action] = String.split(event_and_action, ".")

    repository = payload["repository"]
    event_payload = payload[@event_to_payload_map[event]]
    user = event_payload["user"]

    [repo_owner, repo_name] = repository["full_name"]

    repository = Repositories.get_repository_by_owner_and_name(repo_owner, repo_name)
    user = Users.get_user_by_github_login(user["login"])
    funds = Funds.list_funds_for_repository_and_action(repository, event_and_action)

    if can_reward_contribution?(repository, user, funds) do
      contributions =
        Enum.map(funds, &add_contribution(&1, repository, user, event_and_action, event_payload))

      {:ok, contributions}
    else
      {:error, :unsupported_user_or_repository}
    end
  end

  def handle(_, _) do
    {:error, :invalid_action}
  end

  defp can_reward_contribution?(repository, user, funds) do
    repository != nil && user != nil && Enum.empty?(funds) == false
  end

  defp add_contribution(fund, repository, user, action, event_payload) do
    pledge = Enum.find(fund.pledges, fn pledge -> pledge.action == action end)

    {:ok, transaction_url} =
      Stellar.reward_contribution(
        fund.stellar_public_key,
        user.stellar_public_key,
        pledge.amount,
        "incentivize"
      )

    {:ok, contribution} =
      Contributions.create_contribution(%{
        amount: pledge.amount,
        action: action,
        github_url: event_payload["html_url"],
        stellar_transaction_url: transaction_url,
        pledge_id: pledge.id,
        user_id: user.id,
        repository_id: repository.id
      })

    contribution
  end
end
