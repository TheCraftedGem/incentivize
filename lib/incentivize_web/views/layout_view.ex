defmodule IncentivizeWeb.LayoutView do
  use IncentivizeWeb, :view

  alias IncentivizeWeb.{FundView}

  @spec init_js_module(atom(), binary()) :: binary | {:safe, binary()}
  def init_js_module(view, template)

  def init_js_module(FundView, _) do
    module("Funds")
  end

  def init_js_module(_, _) do
    "null"
  end

  defp module(module) do
    {:safe, "'#{module}'"}
  end
end
