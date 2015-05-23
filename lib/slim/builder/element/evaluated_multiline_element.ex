defmodule Slim.Builder.Element.EvaluatedMultilineElement do
  def match?([element, _contents]), do: Regex.match?(~r(^=\s*), element)
  def match?(_), do: false
  def build([element|contents], padding) do
    content  = contents |> Enum.map(&(Slim.Builder.Element.build(&1, padding))) |> Enum.join

    html = Regex.replace(~r/^=\s*(.*)/, element, "<%= \\1 %>")
    html = html <> content
    html <> "<% end %>"
  end
end
