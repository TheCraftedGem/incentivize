defmodule Incentivize.Factory do
  @moduledoc false
  alias Incentivize.{Fund, Repo, Repository, Stellar, User}

  def build(:user) do
    {:ok, %{"publicKey" => public_key}} = Stellar.generate_random_keypair()

    %User{
      email: "test#{System.unique_integer([:positive])}@example.com",
      github_login: "octocat#{System.unique_integer([:positive])}",
      github_access_token: "12345#{System.unique_integer([:positive])}",
      stellar_public_key: public_key
    }
  end

  def build(:repository) do
    %Repository{
      name: "test#{System.unique_integer([:positive])}",
      owner: "test#{System.unique_integer([:positive])}",
      webhook_secret: "12345",
      admin: build(:user)
    }
  end

  def build(:fund) do
    %Fund{
      pledge_amount: Decimal.new("1.0"),
      repository: build(:repository),
      actions: ["issues.opened"],
      supporter: build(:user)
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
