defmodule Incentivize.Github.API.Webhooks do
  @moduledoc """
  API module for GitHub Webhooks
  """
  alias Incentivize.{Github.API.Base, User}

  @doc """
  Gets info about a webhook for a repository
  """
  @spec get_webhook(User.t(), binary, binary, binary) :: {:ok, map} | {:error, binary}
  def get_webhook(user, owner, name, id) do
    Base.get(user.github_access_token, "/repos/#{owner}/#{name}/hooks/#{id}")
  end

  @doc """
  Gets all webhooks for a repository
  """
  @spec list_webhooks(User.t(), binary, binary) :: {:ok, []} | {:error, binary}
  def list_webhooks(user, owner, name) do
    Base.get(user.github_access_token, "/repos/#{owner}/#{name}/hooks")
  end

  @doc """
  Creates a webhook
  """
  @spec create_webhook(User.t(), binary, binary, map) :: {:ok, map} | {:error, binary}
  def create_webhook(user, owner, name, params) do
    Base.post(user.github_access_token, "/repos/#{owner}/#{name}/hooks", params)
  end
end
