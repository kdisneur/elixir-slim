defmodule Slim.Builder.Element.EvaluatedElementWithSpaces do
  def match?([element]), do: Regex.match?(~r(^='\s*), element)
  def match?(_), do: false
  def build([element], padding), do: String.duplicate(" ", padding) <> Regex.replace(~r/^='\s*(.*)/, element, "&nbsp;<%= \\1 %>") <> Slim.Config.new_line
end
