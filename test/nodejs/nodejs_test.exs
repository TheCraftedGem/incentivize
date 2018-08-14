defmodule Incentivize.NodeJS.Test do
  @moduledoc false
  use Incentivize.DataCase, async: true

  test "echo" do
    assert {:ok, response} = NodeJS.call({:index, :echo}, ["hello"])
    assert response === "hello"
  end
end
