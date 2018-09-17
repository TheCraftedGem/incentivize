defmodule Incentivize.Factory do
  @moduledoc false
  alias Incentivize.{
    Actions,
    Fund,
    Organization,
    Pledge,
    Repo,
    Repository,
    User,
    UserFund,
    UserRepository
  }

  @stellar_module Application.get_env(:incentivize, :stellar_module)

  def build(:user) do
    {:ok, %{"publicKey" => public_key}} = @stellar_module.generate_random_keypair()

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
      webhook_secret: "12345"
    }
  end

  def build(:user_repository) do
    %UserRepository{
      user: build(:user),
      repository: build(:repository)
    }
  end

  def build(:fund) do
    %Fund{
      repository: build(:repository),
      pledges: [build(:pledge)]
    }
  end

  def build(:user_fund) do
    %UserFund{
      user: build(:user),
      fund: build(:fund)
    }
  end

  def build(:pledge) do
    %Pledge{
      amount: Decimal.new("1.0"),
      action: Enum.random(Map.keys(Actions.github_actions()))
    }
  end

  def build(:organization) do
    %Organization{
      name: "organization#{System.unique_integer([:positive])}",
      slug: "organization#{System.unique_integer([:positive])}",
      created_by: build(:user)
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
