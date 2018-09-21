defmodule Incentivize.Factory do
  @moduledoc false
  alias Incentivize.{Actions, Fund, Github.Installation, Pledge, Repo, Repository, User}
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

  def build(:installation) do
    %Installation{
      login: "test#{System.unique_integer([:positive])}",
      login_type: "User",
      installation_id: 12_345
    }
  end

  def build(:repository) do
    %Repository{
      name: "test#{System.unique_integer([:positive])}",
      owner: "test#{System.unique_integer([:positive])}",
      webhook_secret: "12345",
      created_by: build(:user),
      public: true,
      installation_id: 12_345
    }
  end

  def build(:fund) do
    %Fund{
      repository: build(:repository),
      pledges: [build(:pledge)],
      created_by: build(:user)
    }
  end

  def build(:pledge) do
    %Pledge{
      amount: Decimal.new("1.0"),
      action: Enum.random(Map.keys(Actions.github_actions()))
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
