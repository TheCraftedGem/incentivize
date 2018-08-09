defmodule Incentivize.Funds do
  @moduledoc """
  Module for interacting with Funds
  """

  import Ecto.{Query}, warn: false
  alias Incentivize.{Fund, Repo}

  def create_fund(params) do
    %Fund{}
    |> Fund.create_changeset(params)
    |> Repo.insert()
  end

  def get_fund_for_repository(repository, id) do
    Repo.get_by(Fund, repository_id: repository.id, id: id)
  end

  def list_funds_for_repository(repository) do
    Fund
    |> where([f], f.repository_id == ^repository.id)
    |> order_by([f], f.inserted_at)
    |> Repo.all()
  end

  def github_actions do
    [
      "pull_request.opened": "Pull Request Opened",
      # NOTE: 'pull_request.closed' covers both closed and merged PRs. Be sure to check the payload of PR webhook to see if it was merged or just closed
      "pull_request.closed": "Pull Request Closed",
      "issue_comment.created": "Issue Commented",
      "issues.opened": "Issue Opened",
      "issues.closed": "Issue Closed"
    ]
  end
end
