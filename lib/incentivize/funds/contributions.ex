defmodule Incentivize.Contributions do
  @moduledoc """
  Module for interacting with Contributions
  """

  import Ecto.{Query}, warn: false
  alias Incentivize.{Contribution, Repo}

  def create_contribution(params) do
    %Contribution{}
    |> Contribution.changeset(params)
    |> Repo.insert()
  end
end
