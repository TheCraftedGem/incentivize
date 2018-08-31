defmodule Incentivize.Github.API.Repos.Mock do
  @moduledoc false

  def get_public_repo("hi", "hi") do
    {:error, ""}
  end

  def get_public_repo(_, _) do
    {:ok, %{}}
  end
end
