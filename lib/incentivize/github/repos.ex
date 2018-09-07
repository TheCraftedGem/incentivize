defmodule Incentivize.Github.API.Repos do
  @moduledoc """
  API module for GitHub Repos
  """
  alias Incentivize.User
  @base_url "https://api.github.com"

  @doc """
  Gets info about a public repo from github
  """
  @spec get_public_repo(User.t(), binary, binary) :: {:ok, map} | {:error, binary}
  def get_public_repo(user, owner, name) do
    url = "#{@base_url}/repos/#{owner}/#{name}?access_token=#{user.github_access_token}"

    url
    |> HTTPoison.get(headers())
    |> process_response
  end

  @doc """
  Gets all public repos that a user has access to
  """
  @spec get_all_public_repos(User.t()) :: {:ok, []} | {:error, binary}
  def get_all_public_repos(user) do
    url = "#{@base_url}/user/repos?access_token=#{user.github_access_token}&visibility=public"

    url
    |> HTTPoison.get(headers())
    |> process_response
  end

  defp process_response(response, accum \\ []) do
    case response do
      {:ok, %HTTPoison.Response{headers: headers, status_code: 200, body: body}} ->
        link_header = Enum.find(headers, fn header -> elem(header, 0) == "Link" end)
        body = Jason.decode!(body)

        if link_header == nil do
          {:ok, body}
        else
          next_url = process_link_header(link_header)
          accum = accum ++ [body]

          if next_url == nil do
            {:ok, List.flatten(accum)}
          else
            process_response(HTTPoison.get(next_url["url"], headers()), accum)
          end
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not Found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp headers do
    [
      {"User-Agent", "Incentivize"},
      {"Accept", "application/vnd.github.v3+json"}
    ]
  end

  defp process_link_header({"Link", value}) do
    value
    |> String.split(",")
    |> Enum.map(fn page_rel -> String.trim(page_rel) end)
    |> Enum.map(fn page_rel ->
      Regex.named_captures(~r/<(?<url>.*)>; rel="(?<rel>.*)"/, page_rel)
    end)
    |> Enum.find(fn page_rel -> page_rel["rel"] == "next" end)
  end
end
