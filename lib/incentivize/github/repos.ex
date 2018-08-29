defmodule Incentivize.Github.API.Repos do
  @moduledoc """
  API module for GitHub Repos
  """

  @doc """
  Gets info about a public repo from github
  """
  @spec get_public_repo(binary, binary) :: {:ok, map} | {:error, binary}
  def get_public_repo(owner, name) do
    headers = [
      {"User-Agent", "Incentivize"},
      {"Accept", "application/vnd.github.v3+json"}
    ]

    config = Confex.get_env(:incentivize, Incentivize.Github.OAuth, [])
    client_id = Keyword.get(config, :client_id)
    client_secret = Keyword.get(config, :client_secret)

    url =
      "https://api.github.com/repos/#{owner}/#{name}?client_id=#{client_id}&client_secret=#{
        client_secret
      }"

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not Found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
