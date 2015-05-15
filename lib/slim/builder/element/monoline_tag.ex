defmodule Slim.Builder.Element.MonolineTag do
  def match?([element]), do: Regex.match?(~r/^\s*\w+\s*((([a-zA-Z0-9-_]+="[^"]+"\s*|)*)|)(.*)/, element)
  def match?([element|contents]), do: false
  def match?(_), do: false
  def build([element], padding) do
    captured = Regex.named_captures(~r/^\s*(?<tag>\w+)\s*(?<attributes>.*)/, element)
    { attributes, content } = Slim.Builder.Element.Helper.split_attributes_and_content(captured["attributes"])
    Slim.Builder.Element.Helper.build_complex_element(captured["tag"], attributes, Slim.Builder.Element.Helper.interpolate_content(content), padding) <> Slim.Config.new_line
  end
end
