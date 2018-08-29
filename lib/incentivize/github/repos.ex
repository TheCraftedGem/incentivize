defmodule Incentivize.Github.API.Repos do
  @moduledoc """
  API module for GitHub Repos
  """

  @doc """
  Gets info about a public repo from github
  """
  @spec get_public_repo(binary, binary) :: {:ok, map} | {:error, binary}
  def get_public_repo(owner, name) do
    case HTTPoison.get("https://api.github.com/repos/#{owner}/#{name}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not Found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
