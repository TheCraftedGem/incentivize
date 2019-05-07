defmodule IncentivizeWeb.LayoutView do
  use IncentivizeWeb, :view

  alias IncentivizeWeb.{FundView, AccountView, RepositoryView}

  @spec init_js_module(atom(), binary()) :: binary | {:safe, binary()}
  def init_js_module(view, template)

  def init_js_module(FundView, "show.html") do
    module("FundShow")
  end

  def init_js_module(FundView, "new.html") do
    module("FundNew")
  end

  def init_js_module(AccountView, "wallet.html") do
    module("Wallet")
  end

  def init_js_module(RepositoryView, "edit.html") do
    module("LogoUploader")
  end

  def init_js_module(_, _) do
    "null"
  end

  defp module(module) do
    {:safe, "'#{module}'"}
  end
end
