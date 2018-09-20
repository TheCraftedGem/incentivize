defmodule Incentivize.Github.API.Organizations do
  @moduledoc """
  API module for GitHub Organizations
  """
  alias Incentivize.Github.API.Base
  alias Incentivize.User

  @doc """
  Gets information about orgs a user is in
  """
  @spec list_organizations_for_user(User.t()) :: {:ok, map} | {:error, binary}
  def list_organizations_for_user(user) do
    url = "#{Base.base_url()}/user/orgs?access_token=#{user.github_access_token}"

    url
    |> HTTPoison.get(Base.headers())
    |> Base.process_response()
  end
end
