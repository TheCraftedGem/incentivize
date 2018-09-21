defmodule Incentivize.Github.App.Mock do
  @moduledoc false

  def public_url do
    "https://github.com/apps/test"
  end

  def get_user_app_installation_by_github_login(_github_login) do
  end

  def get_organization_app_installation_by_github_login(_github_login) do
  end

  def list_organizations_for_user(_user) do
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

  def get_user(_user) do
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

  def list_user_private_repos(_user) do
    {:ok,
     [
       %{
         "id" => 1_296_269,
         "node_id" => "MDEwOlJlcG9zaXRvcnkxMjk2MjY5",
         "name" => "Hello-World",
         "full_name" => "octocat/Hello-World",
         "owner" => %{
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
           "site_admin" => false
         },
         "private" => false,
         "html_url" => "https://github.com/octocat/Hello-World",
         "description" => "This your first repo!",
         "fork" => false,
         "url" => "https://api.github.com/repos/octocat/Hello-World",
         "archive_url" =>
           "http://api.github.com/repos/octocat/Hello-World/{archive_format}{/ref}",
         "assignees_url" => "http://api.github.com/repos/octocat/Hello-World/assignees{/user}",
         "blobs_url" => "http://api.github.com/repos/octocat/Hello-World/git/blobs{/sha}",
         "branches_url" => "http://api.github.com/repos/octocat/Hello-World/branches{/branch}",
         "collaborators_url" =>
           "http://api.github.com/repos/octocat/Hello-World/collaborators{/collaborator}",
         "comments_url" => "http://api.github.com/repos/octocat/Hello-World/comments{/number}",
         "commits_url" => "http://api.github.com/repos/octocat/Hello-World/commits{/sha}",
         "compare_url" =>
           "http://api.github.com/repos/octocat/Hello-World/compare/{base}...{head}",
         "contents_url" => "http://api.github.com/repos/octocat/Hello-World/contents/{+path}",
         "contributors_url" => "http://api.github.com/repos/octocat/Hello-World/contributors",
         "deployments_url" => "http://api.github.com/repos/octocat/Hello-World/deployments",
         "downloads_url" => "http://api.github.com/repos/octocat/Hello-World/downloads",
         "events_url" => "http://api.github.com/repos/octocat/Hello-World/events",
         "forks_url" => "http://api.github.com/repos/octocat/Hello-World/forks",
         "git_commits_url" => "http://api.github.com/repos/octocat/Hello-World/git/commits{/sha}",
         "git_refs_url" => "http://api.github.com/repos/octocat/Hello-World/git/refs{/sha}",
         "git_tags_url" => "http://api.github.com/repos/octocat/Hello-World/git/tags{/sha}",
         "git_url" => "git:github.com/octocat/Hello-World.git",
         "issue_comment_url" =>
           "http://api.github.com/repos/octocat/Hello-World/issues/comments{/number}",
         "issue_events_url" =>
           "http://api.github.com/repos/octocat/Hello-World/issues/events{/number}",
         "issues_url" => "http://api.github.com/repos/octocat/Hello-World/issues{/number}",
         "keys_url" => "http://api.github.com/repos/octocat/Hello-World/keys{/key_id}",
         "labels_url" => "http://api.github.com/repos/octocat/Hello-World/labels{/name}",
         "languages_url" => "http://api.github.com/repos/octocat/Hello-World/languages",
         "merges_url" => "http://api.github.com/repos/octocat/Hello-World/merges",
         "milestones_url" =>
           "http://api.github.com/repos/octocat/Hello-World/milestones{/number}",
         "notifications_url" =>
           "http://api.github.com/repos/octocat/Hello-World/notifications{?since,all,participating}",
         "pulls_url" => "http://api.github.com/repos/octocat/Hello-World/pulls{/number}",
         "releases_url" => "http://api.github.com/repos/octocat/Hello-World/releases{/id}",
         "ssh_url" => "git@github.com:octocat/Hello-World.git",
         "stargazers_url" => "http://api.github.com/repos/octocat/Hello-World/stargazers",
         "statuses_url" => "http://api.github.com/repos/octocat/Hello-World/statuses/{sha}",
         "subscribers_url" => "http://api.github.com/repos/octocat/Hello-World/subscribers",
         "subscription_url" => "http://api.github.com/repos/octocat/Hello-World/subscription",
         "tags_url" => "http://api.github.com/repos/octocat/Hello-World/tags",
         "teams_url" => "http://api.github.com/repos/octocat/Hello-World/teams",
         "trees_url" => "http://api.github.com/repos/octocat/Hello-World/git/trees{/sha}",
         "clone_url" => "https://github.com/octocat/Hello-World.git",
         "mirror_url" => "git:git.example.com/octocat/Hello-World",
         "hooks_url" => "http://api.github.com/repos/octocat/Hello-World/hooks",
         "svn_url" => "https://svn.github.com/octocat/Hello-World",
         "homepage" => "https://github.com",
         "language" => nil,
         "forks_count" => 9,
         "stargazers_count" => 80,
         "watchers_count" => 80,
         "size" => 108,
         "default_branch" => "master",
         "open_issues_count" => 0,
         "topics" => [
           "octocat",
           "atom",
           "electron",
           "API"
         ],
         "has_issues" => true,
         "has_projects" => true,
         "has_wiki" => true,
         "has_pages" => false,
         "has_downloads" => true,
         "archived" => false,
         "pushed_at" => "2011-01-26T19:06:43Z",
         "created_at" => "2011-01-26T19:01:12Z",
         "updated_at" => "2011-01-26T19:14:43Z",
         "permissions" => %{
           "admin" => false,
           "push" => false,
           "pull" => true
         },
         "allow_rebase_merge" => true,
         "allow_squash_merge" => true,
         "allow_merge_commit" => true,
         "subscribers_count" => 42,
         "network_count" => 0,
         "license" => %{
           "key" => "mit",
           "name" => "MIT License",
           "spdx_id" => "MIT",
           "url" => "https://api.github.com/licenses/mit",
           "node_id" => "MDc6TGljZW5zZW1pdA=="
         }
       }
     ]}
  end
end
