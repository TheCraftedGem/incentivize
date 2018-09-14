defmodule Incentivize.Metrics do
  @moduledoc false
  alias Incentivize.StatCollector
  require Logger

  @behaviour :vmstats_sink

  def collect(_type, name, value) do
    try do
      StatCollector.gauge(IO.iodata_to_binary(name), value, tags: StatCollector.base_tags())
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
        StatCollector.base_tags() ++
          [
            StatCollector.tag("query", entry.query),
            StatCollector.tag("table", entry.source)
          ]

      queue_time = entry.queue_time || 0
      duration = entry.query_time + queue_time

      StatCollector.increment(
        "ecto.query.count",
        1,
        tags: tags
      )

      StatCollector.histogram("ecto.query.exec.time", duration, tags: tags)
      StatCollector.histogram("ecto.query.queue.time", queue_time, tags: tags)
    rescue
      ArgumentError ->
        Logger.warn("Incentivize.Metrics.record_ecto_metric failed")
    catch
      :exit, _value ->
        Logger.warn("Incentivize.Metrics.record_ecto_metric failed")
    end
  end
end
