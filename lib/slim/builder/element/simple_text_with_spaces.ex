defmodule Slim.Builder.Element.SimpleTextWithSpaces do
  def match?([element]), do: Regex.match?(~r(^'\s*), element)
  def match?(_), do: false
  def build([element], padding) do
    element = Regex.replace(~r(^'\s*), Slim.Builder.Element.Helper.interpolate_content(element), "&nbsp;")
    String.duplicate(" ", padding) <> element <> Slim.Config.new_line
  end
end
