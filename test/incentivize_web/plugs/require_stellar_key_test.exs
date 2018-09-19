defmodule IncentivizeWeb.RequireStellarKey.Test do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true
  alias IncentivizeWeb.RequireStellarKey

  test "init" do
    assert RequireStellarKey.init([]) == []
  end
end
