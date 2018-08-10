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

  @doc """
  Generates a random keypair for creating a Stellar account
  """
  @spec generate_random_keypair() :: {:ok, map()}
  def generate_random_keypair do
    NodeJS.call({:repositoryFund, :generateRandomKeyPair}, [])
  end

  @doc """
  Creates a repository fund in stellar.
  Incentivize and the supporter will both have
  permissions to transact on the fund.

  Returns the public key of the escrow account or and error in case of an error
  """
  @spec create_fund_account(binary()) :: {:ok, binary()} | {:error, binary()}
  def create_fund_account(supporter_public_key) do
    NodeJS.call({:repositoryFund, :create}, [network_url(), secret(), supporter_public_key])
  end
end
