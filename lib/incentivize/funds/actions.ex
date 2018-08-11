defmodule Incentivize.Actions do
  @moduledoc """
  Module for GitHub action functions
  """

  def github_actions do
    %{
      "pull_request.opened" => "Pull Request Opened",
      # NOTE: 'pull_request.closed' covers both closed and merged PRs. Be sure to check the payload of PR webhook to see if it was merged or just closed
      "pull_request.closed" => "Pull Request Closed",
      "issue_comment.created" => "Issue Commented",
      "issues.opened" => "Issue Opened",
      "issues.closed" => "Issue Closed"
    }
  end
end
