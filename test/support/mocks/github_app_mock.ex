defmodule Incentivize.Github.App.Mock do
  @moduledoc false

  def public_url do
    "https://github.com/apps/test"
  end

  def get_user_app_installation_by_github_login(github_login) do
  end

  def get_organization_app_installation_by_github_login(github_login) do
  end

  def list_organizations_for_user(user) do
    {:ok,
     [
       %{
         "login" => "github",
         "id" => 1,
         "node_id" => "MDEyOk9yZ2FuaXphdGlvbjE=",
         "url" => "https://api.github.com/orgs/github",
         "repos_url" => "https://api.github.com/orgs/github/repos",
         "events_url" => "https://api.github.com/orgs/github/events",
         "hooks_url" => "https://api.github.com/orgs/github/hooks",
         "issues_url" => "https://api.github.com/orgs/github/issues",
         "members_url" => "https://api.github.com/orgs/github/members{/member}",
         "public_members_url" => "https://api.github.com/orgs/github/public_members{/member}",
         "avatar_url" => "https://github.com/images/error/octocat_happy.gif",
         "description" => "A great organization"
       }
     ]}
  end

  def get_user(user) do
    {:ok,
     %{
       "login" => "octocat",
       "id" => 1,
       "node_id" => "MDQ6VXNlcjE=",
       "avatar_url" => "https://github.com/images/error/octocat_happy.gif",
       "gravatar_id" => "",
       "url" => "https://api.github.com/users/octocat",
       "html_url" => "https://github.com/octocat",
       "followers_url" => "https://api.github.com/users/octocat/followers",
       "following_url" => "https://api.github.com/users/octocat/following{/other_user}",
       "gists_url" => "https://api.github.com/users/octocat/gists{/gist_id}",
       "starred_url" => "https://api.github.com/users/octocat/starred{/owner}{/repo}",
       "subscriptions_url" => "https://api.github.com/users/octocat/subscriptions",
       "organizations_url" => "https://api.github.com/users/octocat/orgs",
       "repos_url" => "https://api.github.com/users/octocat/repos",
       "events_url" => "https://api.github.com/users/octocat/events{/privacy}",
       "received_events_url" => "https://api.github.com/users/octocat/received_events",
       "type" => "User",
       "site_admin" => false,
       "name" => "monalisa octocat",
       "company" => "GitHub",
       "blog" => "https://github.com/blog",
       "location" => "San Francisco",
       "email" => "octocat@github.com",
       "hireable" => false,
       "bio" => "There once was...",
       "public_repos" => 2,
       "public_gists" => 1,
       "followers" => 20,
       "following" => 0,
       "created_at" => "2008-01-14T04:33:35Z",
       "updated_at" => "2008-01-14T04:33:35Z"
     }}
  end
end
