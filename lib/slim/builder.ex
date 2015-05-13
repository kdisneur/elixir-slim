defmodule Slim.Builder do
  def build(elements), do: build(elements, "")
  defp build([], results), do: results
  defp build([[""]|tail], results), do: build(tail, results)
  defp build([element|tail], results), do: build(tail, results <> Slim.Builder.Element.build(element))
end
