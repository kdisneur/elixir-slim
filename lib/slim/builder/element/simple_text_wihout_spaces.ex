defmodule Slim.Builder.Element.SimpleTextWithoutSpaces do
  def match?([element]), do: Regex.match?(~r(^\|\s*), element)
  def match?(_), do: false
  def build([element], padding), do: String.duplicate(" ", padding) <> Regex.replace(~r(^\|\s*), Slim.Builder.Element.Helper.interpolate_content(element), "") <> Slim.Config.new_line
end
