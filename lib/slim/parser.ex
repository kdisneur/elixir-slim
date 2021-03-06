defmodule Slim.Parser do
  def parse(slim) when is_binary(slim), do: slim |> String.split(Slim.Config.new_line) |> parse_trees

  defp parse_trees(elements), do: parse_trees(elements, [])
  defp parse_trees([], results), do: results
  defp parse_trees([head|tail], results), do: parse_trees(tail, insert_line(cleaned_line(head), padding(head), results))

  defp insert_line("", _padding, results), do: results
  defp insert_line(line, 0, []), do: [[line]]
  defp insert_line(line, 0, results), do: results ++ [[line]]
  defp insert_line(line, padding, results) do
    [head|tail] = results |> Enum.reverse
    (tail|>Enum.reverse) ++ [insert_line(line, padding - Slim.Config.default_padding, head)]
  end

  defp cleaned_line(line), do: line |> String.lstrip
  defp padding(line), do: (line |> String.length) - (cleaned_line(line) |> String.length)
end
