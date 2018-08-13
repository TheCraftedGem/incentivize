defmodule Incentivize.Stellar do
  @moduledoc """
  Module for Stellar interactions.
  """

  def public_key, do: config()[:public_key]

  # Keep this private to the module.
  defp secret, do: config()[:secret]

  def has_secret?, do: !is_nil(secret())

  def network_url, do: config()[:network_url]

  defp config do
    Confex.get_env(:incentivize, __MODULE__)
  end

  defp node_js_opts do
    Confex.get_env(:incentivize, :nodejs)
  end

  @doc """
  Generates a random keypair for creating a Stellar account
  """
  @spec generate_random_keypair() :: {:ok, map()}
  def generate_random_keypair do
    make_node_call({:repositoryFund, :generateRandomKeyPair}, [])
  end

  @doc """
  Creates a repository fund in stellar.
  Incentivize and the supporter will both have
  permissions to transact on the fund.

  Returns the public key of the escrow account or and error in case of an error
  """
  @spec create_fund_account(binary()) :: {:ok, binary()} | {:error, binary()}
  def create_fund_account(supporter_public_key) do
    make_node_call(
      {:repositoryFund, :create},
      [network_url(), secret(), supporter_public_key]
    )
  end

  @doc """
  Gives contributor the amount specified from the given fund
  """
  @spec reward_contribution(binary(), binary(), Decimal.t(), binary()) ::
          {:ok, binary()} | {:error, binary()}
  def reward_contribution(fund_public_key, contributor_public_key, amount, memo_text) do
    make_node_call(
      {:repositoryFund, :rewardContribution},
      [
        network_url(),
        secret(),
        fund_public_key,
        contributor_public_key,
        Decimal.to_string(amount),
        memo_text
      ]
    )
  end

  def add_funds_to_account(fund_public_key, amount, memo_text) do
    make_node_call(
      {:repositoryFund, :addFunds},
      [
        network_url(),
        secret(),
        fund_public_key,
        Decimal.to_string(amount),
        memo_text
      ]
    )
  end

  defp make_node_call(func, args) do
    try do
      NodeJS.call(func, args, node_js_opts())
    catch
      :exit, _value ->
        {:error, :node_process_exited}
    end
  end
end
