defmodule IncentivizeWeb.Parsers.JSON do
  @moduledoc """
  Parses JSON request body.

  JSON arrays are parsed into a `"_json"` key to allow
  proper param merging.

  An empty request body is parsed as an empty map.

  ## Options

  All options supported by `Plug.Conn.read_body/2` are also supported here.
  They are repeated here for convenience:

    * `:length` - sets the maximum number of bytes to read from the request,
      defaults to 8_000_000 bytes
    * `:read_length` - sets the amount of bytes to read at one time from the
      underlying socket to fill the chunk, defaults to 1_000_000 bytes
    * `:read_timeout` - sets the timeout for each socket read, defaults to
      15_000ms

  So by default, `Plug.Parsers` will read 1_000_000 bytes at a time from the
  socket with an overall limit of 8_000_000 bytes.
  """

  @behaviour Plug.Parsers
  import Plug.Conn

  def init(opts) do
    {decoder, opts} = Keyword.pop(opts, :json_decoder)

    unless decoder do
      raise ArgumentError, "JSON parser expects a :json_decoder option"
    end

    {decoder, opts}
  end

  def parse(conn, "application", subtype, _headers, {decoder, opts}) do
    if subtype == "json" or String.ends_with?(subtype, "+json") do
      conn
      |> read_body(opts)
      |> decode(decoder)
    else
      {:next, conn}
    end
  end

  def parse(conn, _type, _subtype, _headers, _opts) do
    {:next, conn}
  end

  defp decode({:ok, "", conn}, _decoder) do
    {:ok, %{}, conn}
  end

  defp decode({:ok, body, conn}, decoder) do
    conn = assign(conn, :raw_body, body)

    case apply_mfa_or_module(body, decoder) do
      terms when is_map(terms) ->
        {:ok, terms, conn}

      terms ->
        {:ok, %{"_json" => terms}, conn}
    end
  rescue
    e -> raise Plug.Parsers.ParseError, exception: e
  end

  defp decode({:more, _, conn}, _decoder) do
    {:error, :too_large, conn}
  end

  defp decode({:error, :timeout}, _decoder) do
    raise Plug.TimeoutError
  end

  defp decode({:error, _}, _decoder) do
    raise Plug.BadRequestError
  end

  defp apply_mfa_or_module(body, {module_name, function_name, extra_args}) do
    apply(module_name, function_name, [body | extra_args])
  end

  defp apply_mfa_or_module(body, decoder) do
    decoder.decode!(body)
  end
end
