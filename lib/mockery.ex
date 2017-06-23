defmodule Mockery do
  def return(mod, fun, value) do
    Process.put(dict_key(mod, fun), value)
  end

  defmacro __using__(opts) do
    mod = opts |> Keyword.fetch!(:module)

    generate_funs(mod)
  end

  defp generate_funs(mod) do
    dod = mod
    mod = Macro.expand(mod, __ENV__)

    mod.__info__(:functions)
    |> Enum.map(fn {name, arity} ->
      args = mkargs(__ENV__.module, arity)

      key1 = dict_key(dod, [{name, arity}])
      key2 = dict_key(mod, name)

      quote do
        def unquote(name)(unquote_splicing(args)) do
          case Process.get(unquote(key1)) || Process.get(unquote(key2)) do
            nil ->
              apply(unquote(mod), unquote(name), [unquote_splicing(args)])
            value ->
              value
          end
        end
      end
    end)
  end

  # note to myself: dont use three element tuples
  defp dict_key(mod, [{funn, arity}]), do: {mod, {funn, arity}}
  defp dict_key(mod, funn), do: {mod, funn}

  # shamelessly stolen from
  # https://gist.github.com/teamon/f759a4ced0e21b02a51dda759de5da03
  defp mkargs(_, 0), do: []
  defp mkargs(mod, n), do: Enum.map(1..n, &Macro.var(:"arg#{&1}", mod))
end