defmodule IncentivizeWeb.LayoutView do
  use IncentivizeWeb, :view
  alias Incentivize.User

  alias IncentivizeWeb.{
    FundView,
    RepositoryView
  }

  @spec logged_in?(Plug.Conn.t()) :: boolean()
  def logged_in?(conn) do
    case conn.assigns.current_user do
      nil -> false
      %User{} -> true
    end
  end

  @spec init_js_module(atom(), binary()) :: binary | {:safe, binary()}
  def init_js_module(view, template)

  def init_js_module(FundView, _) do
    module("Funds")
  end

  def init_js_module(RepositoryView, _) do
    module("Repositories")
  end

  def init_js_module(_, _) do
    "null"
  end

  defp module(module) do
    {:safe, "'#{module}'"}
  end
end
