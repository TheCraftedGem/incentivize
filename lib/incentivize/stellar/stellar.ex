defmodule Incentivize.Stellar do
  @moduledoc """
  Module for Stellar interactions.
  """

  def public_key, do: config()[:public_key]

  # Keep this private to the module.
  defp secret, do: config()[:secret]

  def has_secret?, do: !is_nil(secret())

  def network_url, do: config()[:network_url]

  def test_network?, do: String.contains?(network_url(), "test")

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
    {public, secret} = Stellar.KeyPair.random()

    {:ok,
     %{
       "publicKey" => public,
       "secret" => secret
     }}
  end

  @doc """
  Creates a repository fund in stellar.
  Incentivize and the supporter will both have
  permissions to transact on the fund.

  Returns the public key of the escrow account or and error in case of an error
  """
  @spec create_fund_account(binary()) :: {:ok, binary()} | {:error, binary()}
  def create_fund_account(supporter_public_key) do
    with {:ok, {escrow_public, escrow_secret}} <- generate_escrow_account_xdr(),
         {:ok, _} <- set_weights_xdr(supporter_public_key, escrow_secret) do
      {:ok, escrow_public}
    else
      error ->
        error
    end
  end

  defp generate_escrow_account_xdr do
    {escrow_public, escrow_secret} = Stellar.KeyPair.random()
    starting_balance = "2.5000000"

    {:ok, xdr} =
      make_node_call(
        {:repositoryFund, :generateEscrowAccountXDR},
        [
          network_url(),
          secret(),
          escrow_public,
          starting_balance
        ]
      )

    case Stellar.Transactions.post(xdr) do
      {:ok, _result} ->
        {:ok, {escrow_public, escrow_secret}}

      error ->
        error
    end
  end

  defp set_weights_xdr(supporter_public_key, escrow_secret) do
    {:ok, xdr} =
      make_node_call(
        {:repositoryFund, :setWeightsXDR},
        [
          network_url(),
          escrow_secret,
          supporter_public_key,
          public_key()
        ]
      )

    Stellar.Transactions.post(xdr)
  end

  @doc """
  Gives contributor the amount specified from the given fund
  """
  @spec reward_contribution(binary(), binary(), Decimal.t(), binary()) ::
          {:ok, binary()} | {:error, binary()}
  def reward_contribution(fund_public_key, contributor_public_key, amount, memo_text) do
    {:ok, transaction_xdr} =
      make_node_call(
        {:repositoryFund, :rewardContributionXDR},
        [
          network_url(),
          secret(),
          fund_public_key,
          contributor_public_key,
          Decimal.to_string(amount),
          memo_text
        ]
      )

    case Stellar.Transactions.post(transaction_xdr) do
      {:ok, result} ->
        {:ok, get_in(result, ["_links", "transaction", "href"])}

      error ->
        error
    end
  end

  def add_funds_to_account(fund_public_key, amount, memo_text) do
    {:ok, xdr} =
      make_node_call(
        {:repositoryFund, :addFundsXDR},
        [
          network_url(),
          secret(),
          fund_public_key,
          Decimal.to_string(amount),
          memo_text
        ]
      )

    Stellar.Transactions.post(xdr)
  end

  # Indirect to nodejs process in order to capture
  # any process-level errors
  defp make_node_call(func, args) do
    try do
      NodeJS.call(func, args, node_js_opts())
    catch
      :exit, _value ->
        {:error, "node_process_exited"}
    end
  end
end
