defmodule Slim.Builder.Element.MultilineTag do
  def match?([element|contents]) when length(contents) > 0, do: Regex.match?(~r/^\s*(\w+)\s*.*$/, element)
  def match?(_), do: false
  def build([element|contents], padding) do
    captured = Regex.named_captures(~r/^\s*(?<tag>\w+)\s*(?<attributes>.*)$/, element)
    {attributes, ""} = Slim.Builder.Element.Helper.split_attributes_and_content(captured["attributes"])
    content  = contents |> Enum.map(&(Slim.Builder.Element.build(&1, padding + Slim.Config.default_padding))) |> Enum.join
    Slim.Builder.Element.Helper.build_complex_element(captured["tag"], attributes, content, padding, true) <> Slim.Config.new_line
  end
end
