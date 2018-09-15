defmodule IncentivizeWeb.Instrumenter do
  @moduledoc false

  alias Incentivize.StatCollector

  @doc false
  def phoenix_controller_call(:start, _compile_metadata, runtime_metadata) do
    StatCollector.increment("phoenix.request.count", 1, tags: tags(runtime_metadata.conn))

    runtime_metadata
  end

  @doc false
  def phoenix_controller_call(:stop, diff, result_of_before_callback) do
    StatCollector.increment("phoenix.response.count", 1,
      tags: tags(result_of_before_callback.conn)
    )

    StatCollector.histogram("phoenix.response.time", diff,
      tags: tags(result_of_before_callback.conn)
    )
  end

  defp tags(conn) do
    user_tag =
      if Map.has_key?(conn.assigns, :current_user) and conn.assigns.current_user != nil do
        StatCollector.tag("user", conn.assigns.current_user.id)
      else
        nil
      end

    tags =
      StatCollector.base_tags() ++
        [
          StatCollector.tag("method", conn.method),
          StatCollector.tag("path", conn.request_path),
          StatCollector.tag("query", conn.query_string),
          StatCollector.tag("action", conn.private.phoenix_action),
          StatCollector.tag("controller", inspect(conn.private.phoenix_controller)),
          StatCollector.tag("user", get_in(conn.assigns, ["current_user", "id"])),
          user_tag
        ]

    Enum.reject(tags, fn x -> is_nil(x) end)
  end
end
