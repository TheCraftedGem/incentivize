defmodule Incentivize.Stellar.Test do
  use Incentivize.DataCase, async: true
  alias Incentivize.Stellar

  test "network_url is set" do
    refute nil == Stellar.network_url()
  end

  test "public_key is set" do
    refute nil == Stellar.public_key()
  end

  test "secret is set" do
    assert Stellar.has_secret?()
  end

  test "generate_random_keypair/0 succeeds" do
    assert {:ok, %{"publicKey" => public, "secret" => secret}} = Stellar.generate_random_keypair()
    assert is_bitstring(public)
    refute public === ""
    assert is_bitstring(secret)
    refute secret === ""
  end

  test "create_fund_account/1 succeeds" do
    assert {:ok, %{"publicKey" => public}} = Stellar.generate_random_keypair()
    assert {:ok, result} = Stellar.create_fund_account(public)
  end

  test "reward_contribution/1 succeeds" do
    assert {:ok, %{"publicKey" => public}} = Stellar.generate_random_keypair()
    assert {:ok, %{"publicKey" => contributer_public}} = Stellar.generate_random_keypair()
    assert {:ok, result} = Stellar.create_fund_account(public)

    assert {:ok, _transaction_url} =
             Stellar.add_funds_to_account(result, Decimal.new(20), "Lumens")

    Stellar.reward_contribution(result, contributer_public, Decimal.new(1), "A memo")
  end
end
