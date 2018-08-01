defmodule Incentivize.Factory do
  alias Incentivize.{User, Repo}

  def build(:user) do
    %User{
      email: "test#{System.unique_integer([:positive])}@example.com",
      github_login: "octocat",
      github_access_token: "12345"
    }
  end

  def build(factory_name, attributes \\ []) do
    factory_name |> build() |> struct(attributes)
  end

  def params_for(factory_name, attributes \\ []) do
    factory_name |> build() |> struct(attributes) |> Map.from_struct()
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert!(build(factory_name, attributes))
  end
end
