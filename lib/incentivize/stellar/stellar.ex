defmodule Incentivize.Stellar do
  @moduledoc """
  Module for Stellar interactions.
  """

  def public_key, do: config()[:public_key]

  def secret, do: config()[:secret]

  def network_url, do: config()[:network_url]

  defp config do
    Confex.get_env(:incentivize, __MODULE__)
  end

  def create_fund_account(supporter_public_key) do
    NodeJS.call({:repositoryFund, :create}, [network_url(), secret(), supporter_public_key])
  end
end
