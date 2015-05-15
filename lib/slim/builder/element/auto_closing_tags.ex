defmodule Slim.Builder.Element.AutoClosingTags do
  def match?([element|tail]), do: Regex.match?(~r/^\s*(br|hr|img|input|meta)\s*((([a-zA-Z0-9-_]+="[^"]+"\s*|)*)|)\s*/, element)
  def match?(_), do: false
  def build([element], padding) do
    captured = Regex.named_captures(~r/^\s*(?<tag>\w+)\s*((?<attributes>([a-zA-Z0-9-_]+="[^"]+"\s*|)*)|)\s*/, Slim.Builder.Element.Helper.interpolate_content(element))
    html_element = String.duplicate(" ", padding) <> "<" <> captured["tag"]
    if String.length(captured["attributes"]) > 0, do: html_element = html_element <> " " <> String.lstrip(captured["attributes"])
    html_element <> ">" <> Slim.Config.new_line
  end
end
