defmodule Incentivize.Github.API.Users do
  @moduledoc """
  API module for GitHub Users
  """
  alias Incentivize.Github.API.Base
  alias Incentivize.User

  @doc """
  Gets information about a user
  """
  @spec get_user(User.t()) :: {:ok, map} | {:error, binary}
  def get_user(user) do
    url = "#{Base.base_url()}/user?access_token=#{user.github_access_token}"

    url
    |> HTTPoison.get(Base.headers())
    |> Base.process_response()
  end
end
