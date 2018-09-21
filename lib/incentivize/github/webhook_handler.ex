defmodule Incentivize.Github.WebhookHandler do
  @moduledoc """
  Handles processing of GitHub webhooks
  """
  alias Incentivize.{
    Actions,
    Funds,
    Github.ContributionWorker,
    Github.Installations,
    Repositories,
    Users
  }

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

  # New Installation is created
  # Add a record of if and add associated repos as well
  def handle("installation.created", payload) do
    Installations.create_installation(%{
      installation_id: get_in(payload, ["installation", "id"]),
      login: get_in(payload, ["installation", "account", "login"]),
      login_type: get_in(payload, ["installation", "account", "type"])
    })

    add_repositories_from_installation(
      payload["repositories"],
      get_in(payload, ["installation", "id"])
    )

    {:ok, :installation_created}
  end

  # Installation deleted
  # Remove it and soft delete repos
  def handle("installation.deleted", payload) do
    installation_id = get_in(payload, ["installation", "id"])
    Installations.delete_installation(installation_id)

    {:ok, :installation_deleted}
  end

  # Repos added to installation
  # Add them and associate with installation
  def handle("installation_repositories.added", payload) do
    add_repositories_from_installation(
      payload["repositories_added"],
      get_in(payload, ["installation", "id"])
    )

    {:ok, :installation_repositories_added}
  end

  # Repos removed from installation
  # remove them
  def handle("installation_repositories.removed", payload) do
    repos =
      payload["repositories_removed"]
      |> Enum.map(fn %{"full_name" => full_name} ->
        [owner, name] = String.split(full_name, "/")
        Repositories.get_repository_by_owner_and_name(owner, name)
      end)
      |> Enum.reject(fn x -> is_nil(x) end)

    Repositories.delete_repositories(repos)

    {:ok, :installation_repositories_removed}
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

  defp add_repositories_from_installation(repos, installation_id) do
    Enum.each(repos, fn %{"full_name" => full_name, "private" => private} ->
      [owner, name] = String.split(full_name, "/")
      repository = Repositories.get_repository_by_owner_and_name_include_deleted(owner, name)

      # Create new repo if it does not exist already
      if is_nil(repository) do
        {:ok, repository} =
          Repositories.create_repository(%{
            owner: owner,
            name: name,
            public: !private,
            installation_id: installation_id
          })

        repository
      else
        # if it already exists but is deleted, undelete it
        # the installation id could have changed so update that as well
        if is_nil(repository.deleted_at) == false do
          Repositories.undelete_repository(repository, installation_id)
        end
      end
    end)
  end
end
