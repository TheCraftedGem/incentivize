defmodule Incentivize.Github.API.Base do
  @moduledoc """
  API module for GitHub Repos
  """
  @base_url "https://api.github.com"

  @spec get(binary, binary, list) :: {:ok, map} | {:error, binary}
  def get(github_access_token, endpoint, query_params \\ []) do
    url = "#{@base_url}#{endpoint}" <> process_query_params(github_access_token, query_params)

    url
    |> HTTPoison.get(headers())
    |> process_response
  end

  @spec post(binary, binary, any, list) :: {:ok, map} | {:error, binary}
  def post(github_access_token, endpoint, body, query_params \\ []) do
    url = "#{@base_url}#{endpoint}" <> process_query_params(github_access_token, query_params)

    url
    |> HTTPoison.post(headers(), body)
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

  defp process_query_params(github_access_token, []), do: "?access_token=#{github_access_token}"

  defp process_query_params(github_access_token, params) do
    "?access_token=#{github_access_token}&" <> URI.encode_query(params)
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
