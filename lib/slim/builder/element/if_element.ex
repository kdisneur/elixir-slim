defmodule Slim.Builder.Element.IfElement do
  def match?([element|_contents]), do: Regex.match?(~r/^-\s*if[\s\(]/, element)
  def match?(_), do: false
  def build([element|contents], padding) do
    content  = contents |> Enum.map(&(Slim.Builder.Element.build(&1, padding))) |> Enum.join

    html = Regex.replace(~r/^-\s*(.*)/, element, "<%= \\1 %>")
    html = html <> content
    html = html <> "<% end %>"
  end
end
