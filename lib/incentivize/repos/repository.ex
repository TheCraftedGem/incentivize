defmodule Incentivize.Repository do
  @moduledoc """
  Repository Schema
  """

  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Incentivize.{Contribution, Fund, Repository, User}

  @type t :: %__MODULE__{}
  schema "repositories" do
    field(:name, :string)
    field(:owner, :string)
    field(:webhook_secret, :string)
    field(:public, :boolean, default: true)
    field(:deleted_at, :utc_datetime)
    field(:installation_id, :integer)
    has_many(:funds, Fund)
    has_many(:contributions, Contribution)
    belongs_to(:created_by, User)
    timestamps()
  end

  def create_changeset(%Repository{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :owner,
      :created_by_id,
      :public,
      :installation_id
    ])
    |> validate_required([:name, :owner, :public, :installation_id])
    |> unique_constraint(:owner,
      name: "repositories_owner_name_index",
      message: "Repository already connected."
    )
    |> put_change(:webhook_secret, random_string(32))
  end

  def update_changeset(%Repository{} = model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :owner,
      :webhook_secret,
      :created_by_id,
      :deleted_at,
      :public,
      :installation_id
    ])
    |> validate_required([:name, :owner, :webhook_secret, :public, :installation_id])
  end

  defp random_string(length) do
    length |> :crypto.strong_rand_bytes() |> Base.encode64() |> binary_part(0, length)
  end
end

%{
  "action" => "deleted",
  "installation" => %{
    "access_tokens_url" => "https://api.github.com/installations/348284/access_tokens",
    "account" => %{
      "avatar_url" => "https://avatars3.githubusercontent.com/u/1257573?v=4",
      "events_url" => "https://api.github.com/users/bryanjos/events{/privacy}",
      "followers_url" => "https://api.github.com/users/bryanjos/followers",
      "following_url" => "https://api.github.com/users/bryanjos/following{/other_user}",
      "gists_url" => "https://api.github.com/users/bryanjos/gists{/gist_id}",
      "gravatar_id" => "",
      "html_url" => "https://github.com/bryanjos",
      "id" => 1_257_573,
      "login" => "bryanjos",
      "node_id" => "MDQ6VXNlcjEyNTc1NzM=",
      "organizations_url" => "https://api.github.com/users/bryanjos/orgs",
      "received_events_url" => "https://api.github.com/users/bryanjos/received_events",
      "repos_url" => "https://api.github.com/users/bryanjos/repos",
      "site_admin" => false,
      "starred_url" => "https://api.github.com/users/bryanjos/starred{/owner}{/repo}",
      "subscriptions_url" => "https://api.github.com/users/bryanjos/subscriptions",
      "type" => "User",
      "url" => "https://api.github.com/users/bryanjos"
    },
    "app_id" => 16505,
    "created_at" => "2018-09-24T13:42:53.000Z",
    "events" => [
      "issues",
      "issue_comment",
      "pull_request",
      "pull_request_review",
      "pull_request_review_comment",
      "repository"
    ],
    "html_url" => "https://github.com/settings/installations/348284",
    "id" => 348_284,
    "permissions" => %{"issues" => "read", "metadata" => "read", "pull_requests" => "read"},
    "repositories_url" => "https://api.github.com/installation/repositories",
    "repository_selection" => "all",
    "single_file_name" => nil,
    "target_id" => 1_257_573,
    "target_type" => "User",
    "updated_at" => "2018-09-24T13:42:53.000Z"
  },
  "sender" => %{
    "avatar_url" => "https://avatars3.githubusercontent.com/u/1257573?v=4",
    "events_url" => "https://api.github.com/users/bryanjos/events{/privacy}",
    "followers_url" => "https://api.github.com/users/bryanjos/followers",
    "following_url" => "https://api.github.com/users/bryanjos/following{/other_user}",
    "gists_url" => "https://api.github.com/users/bryanjos/gists{/gist_id}",
    "gravatar_id" => "",
    "html_url" => "https://github.com/bryanjos",
    "id" => 1_257_573,
    "login" => "bryanjos",
    "node_id" => "MDQ6VXNlcjEyNTc1NzM=",
    "organizations_url" => "https://api.github.com/users/bryanjos/orgs",
    "received_events_url" => "https://api.github.com/users/bryanjos/received_events",
    "repos_url" => "https://api.github.com/users/bryanjos/repos",
    "site_admin" => false,
    "starred_url" => "https://api.github.com/users/bryanjos/starred{/owner}{/repo}",
    "subscriptions_url" => "https://api.github.com/users/bryanjos/subscriptions",
    "type" => "User",
    "url" => "https://api.github.com/users/bryanjos"
  }
}
