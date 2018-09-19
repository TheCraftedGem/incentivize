defmodule IncentivizeWeb.RequireAuth.Test do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true
  alias IncentivizeWeb.RequireAuth

  test "init" do
    assert RequireAuth.init([]) == []
  end
end
