defmodule Slim.Builder.Element.AutoClosingTags do
  def match?([element|_tail]), do: Regex.match?(~r/^\s*(br|hr|img|input|meta)\s*.*$/, element)
  def match?(_), do: false
  def build([element], padding) do
    captured = Regex.named_captures(~r/^\s*(?<tag>\w+)\s*(?<attributes>.*)$/, element)
    {attributes, ""} = Slim.Builder.Element.Helper.split_attributes_and_content(captured["attributes"])
    attributes =  Slim.Builder.Element.Helper.interpolate_content(attributes |> Enum.join(" "))

    html_element = String.duplicate(" ", padding) <> "<" <> captured["tag"]
    if String.length(attributes) > 0, do: html_element = html_element <> " " <> attributes
    html_element <> ">" <> Slim.Config.new_line
  end
end
