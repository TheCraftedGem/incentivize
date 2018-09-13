defmodule Incentivize.Metrics do
  @moduledoc false
  alias Incentivize.Statix
  require Logger

  @behaviour :vmstats_sink

  def collect(_type, name, value) do
    try do
      Statix.gauge(IO.iodata_to_binary(name), value, tags: Statix.base_tags())
    rescue
      ArgumentError ->
        Logger.warn("Incentivize.Metrics.collect failed")
    catch
      :exit, _value ->
        Logger.warn("Incentivize.Metrics.collect failed")
    end
  end

  def record_ecto_metric(entry) do
    try do
      tags =
        Statix.base_tags() ++
          [
            "query:#{entry.query}",
            "table:#{entry.source}"
          ]

      queue_time = entry.queue_time || 0
      duration = entry.query_time + queue_time

      Statix.increment(
        "ecto.query.count",
        1,
        tags: tags
      )

      Statix.histogram("ecto.query.exec.time", duration, tags: tags)
      Statix.histogram("ecto.query.queue.time", queue_time, tags: tags)
    rescue
      ArgumentError ->
        Logger.warn("Incentivize.Metrics.record_ecto_metric failed")
    catch
      :exit, _value ->
        Logger.warn("Incentivize.Metrics.record_ecto_metric failed")
    end
  end
end
