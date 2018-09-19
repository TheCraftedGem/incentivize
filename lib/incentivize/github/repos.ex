defmodule Incentivize.Github.API.Repos do
  @moduledoc """
  API module for GitHub Repos
  """
  alias Incentivize.Github.API.Base
  alias Incentivize.User

  @doc """
  Gets info about a public repo from github
  """
  @spec get_public_repo(User.t(), binary, binary) :: {:ok, map} | {:error, binary}
  def get_public_repo(user, owner, name) do
    url = "#{Base.base_url()}/repos/#{owner}/#{name}?access_token=#{user.github_access_token}"

    url
    |> HTTPoison.get(Base.headers())
    |> Base.process_response()
  end

  @doc """
  Gets all public repos that a user has access to
  """
  @spec get_all_public_repos(User.t()) :: {:ok, []} | {:error, binary}
  def get_all_public_repos(user) do
    url =
      "#{Base.base_url()}/user/repos?access_token=#{user.github_access_token}&visibility=public"

    url
    |> HTTPoison.get(Base.headers())
    |> Base.process_response()
  end
end
