defmodule Incentivize.Github.API.Repos.Mock do
  @moduledoc false

  def get_public_repo(_, "hi", "hi") do
    {:error, ""}
  end

  def get_public_repo(_, _, _) do
    {:ok, %{}}
  end

  def get_all_public_repos(_) do
    {:ok, []}
  end
end
