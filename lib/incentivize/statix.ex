defmodule Incentivize.StatCollector do
  @moduledoc false
  use Statix, runtime_config: true

  def base_tags do
    {hostname, 0} = System.cmd("hostname", [])
    hostname = String.replace(hostname, "\n", "")

    [
      tag("app", "incentivize"),
      tag("pod_name", hostname)
    ]
  end

  def tag(key, value) when value in ["", nil], do: nil
  def tag(key, value), do: "#{key}:#{value}"
end
