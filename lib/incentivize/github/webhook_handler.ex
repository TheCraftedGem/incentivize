defmodule Incentivize.Github.WebhookHandler do
  @moduledoc """
  Handles processing of GitHub webhooks
  """
  alias Incentivize.{Actions, Funds, Github.ContributionWorker, Repositories, Users}
  @actions Map.keys(Actions.github_actions())
  @event_to_payload_map %{
    "issues" => "issue",
    "issue_comment" => "comment",
    "pull_request" => "pull_request"
  }

  @doc """
  Takes in GitHub event payload and process contributions

  Checks to see if action is incentivized and user exists.
  If so, then they are given the amount of XLM specified
  by the pledge for that action and repo. This checks for
  all pledges for the repo so may give more than one contribution
  if multiple pledges exist.
  """
  @spec handle(binary(), map()) :: {:ok, :scheduled} | {:error, atom}
  def handle(event_and_action, payload) when event_and_action in @actions do
    [event, _action] = String.split(event_and_action, ".")

    repository = payload["repository"]
    event_payload = payload[@event_to_payload_map[event]]
    user = event_payload["user"]

    [repo_owner, repo_name] = String.split(repository["full_name"], "/")

    repository = Repositories.get_repository_by_owner_and_name(repo_owner, repo_name)
    user = Users.get_user_by_github_login(user["login"])
    pledges = Funds.list_pledges_for_repository_and_action(repository, event_and_action)

    if can_reward_contribution?(event_and_action, event_payload, repository, user, pledges) do
      Enum.each(
        pledges,
        fn pledge ->
          Rihanna.enqueue(ContributionWorker, [
            pledge.id,
            repository.id,
            user.id,
            event_and_action,
            event_payload["html_url"]
          ])
        end
      )

      {:ok, :scheduled}
    else
      {:error, :ineligible}
    end
  end

  def handle(_, _) do
    {:error, :unsupported}
  end

  # Make sure PR was merged and not just closed
  defp can_reward_contribution?("pull_request.closed", event_payload, repository, user, pledges) do
    event_payload["merged"] == true && repository != nil && user != nil &&
      Enum.empty?(pledges) == false
  end

  defp can_reward_contribution?(_event_and_action, _payload, repository, user, pledges) do
    repository != nil && user != nil && Enum.empty?(pledges) == false
  end
end
