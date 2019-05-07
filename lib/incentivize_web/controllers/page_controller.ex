defmodule IncentivizeWeb.PageController do
  use IncentivizeWeb, :controller
  alias Incentivize.{Flags, Stellar}

  action_fallback(IncentivizeWeb.FallbackController)

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def pricing(conn, _params) do
    if Flags.enable_pricing?() do
      app_fee_percentage =
        Stellar.app_fee_percentage()
        |> Decimal.new()
        |> Decimal.mult(Decimal.new(100))
        |> Decimal.round(0)
        |> Decimal.to_string()

      app_fee_precentage_display = "#{app_fee_percentage}%"
      render(conn, "pricing.html", app_fee_precentage_display: app_fee_precentage_display)
    else
      :not_found
    end
  end
end
