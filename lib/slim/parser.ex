defmodule Slim.Parser do
  @default_padding 2
  @new_line        "\n"

  def parse(slim) when is_binary(slim), do: slim |> String.split(@new_line) |> parse(0, [])
  defp parse([], _next_padding, results), do: results
  defp parse(elements, next_padding, results) do
    { children, tail } = find_children(elements, next_padding, results)
    parse(tail, next_padding, children)
  end

  defp cleaned_line(line), do: line |> String.lstrip
  defp padding(line), do: (line |> String.length) - (cleaned_line(line) |> String.length)

  defp find_children([], _next_padding, results), do: { results, [] }
  defp find_children([line|tail], next_padding, results) do
    case padding(line) do
      current_padding when current_padding > next_padding  -> raise "Malformed files. Check your indentation: " <> line
      current_padding when current_padding == next_padding ->
        case find_children(tail, current_padding + @default_padding, []) do
          {[], tail}       ->
            { children, tail } = find_children(tail, current_padding, [])
            {results ++ [[cleaned_line(line)]] ++ children, tail}
          {children, tail} -> {results ++ [[cleaned_line(line)] ++ children], tail}
        end
      _ -> {[], [line] ++ tail}
    end
  end
end
