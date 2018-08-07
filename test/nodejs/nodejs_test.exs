defmodule Incentivize.NodeJS.Test do
  use Incentivize.DataCase

  test "echo" do
    assert {:ok, response} = NodeJS.call({:index, :echo}, ["hello"])
    assert response === "hello"
  end
end
