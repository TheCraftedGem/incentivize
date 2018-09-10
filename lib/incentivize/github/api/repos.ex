defmodule Incentivize.Github.API.Repos do
  @moduledoc """
  API module for GitHub Repos
  """
  alias Incentivize.{Github.API.Base, User}

  @doc """
  Gets info about a public repo from github
  """
  @spec get_public_repo(User.t(), binary, binary) :: {:ok, map} | {:error, binary}
  def get_public_repo(user, owner, name) do
    Base.get(user.github_access_token, "/repos/#{owner}/#{name}")
  end

  @doc """
  Gets all public repos that a user has access to
  """
  @spec get_all_public_repos(User.t()) :: {:ok, []} | {:error, binary}
  def get_all_public_repos(user) do
    Base.get(user.github_access_token, "/user/repos", visibility: "public")
  end
end
