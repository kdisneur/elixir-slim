defmodule Slim.Builder.Element do
  def build(element), do: build(element, 0)
  def build(element, padding), do: find_builder(element).build(element, padding)

  defp find_builder(element) do
    [
      Slim.Builder.Element.SimpleTextWithoutSpaces,
      Slim.Builder.Element.SimpleTextWithSpaces,
      Slim.Builder.Element.EvaluatedElement,
      Slim.Builder.Element.MultilineTag,
      Slim.Builder.Element.MonolineTag
    ] |> Enum.find(&(&1.match?(element)))
  end

  defmodule SimpleTextWithoutSpaces do
    def match?([element]), do: Regex.match?(~r(^\|\s*), element)
    def match?(_), do: false
    def build([element], padding), do: String.duplicate(" ", padding) <> Regex.replace(~r(^\|\s*), element, "") <> Slim.Config.new_line
  end

  defmodule SimpleTextWithSpaces do
    def match?([element]), do: Regex.match?(~r(^'\s*), element)
    def match?(_), do: false
    def build([element], padding), do: String.duplicate(" ", padding) <> Regex.replace(~r(^'\s*), element, "&nbsp;") <> Slim.Config.new_line
  end

  defmodule EvaluatedElement do
    def match?([element]), do: Regex.match?(~r(^=\s*), element)
    def match?(_), do: false
    def build([element], padding), do: String.duplicate(" ", padding) <> Regex.replace(~r(^=\s*), element, "executed! ") <> Slim.Config.new_line
  end

  defmodule MonolineTag do
    def match?([element]), do: Regex.match?(~r/^\s*\w+\s*((([a-zA-Z0-9-_]+="[^"]+"\s*|)*)|)(.*)/, element)
    def match?([element|contents]), do: false
    def match?(_), do: false
    def build([element], padding) do
      captured = Regex.named_captures(~r/^\s*(?<tag>\w+)\s*((?<attributes>([a-zA-Z0-9-_]+="[^"]+"\s*|)*)|)(?<content>.*)/, element)
      Slim.Builder.Element.build_complex_element(captured["tag"], captured["attributes"], captured["content"], padding) <> Slim.Config.new_line
    end
  end

  defmodule MultilineTag do
    def match?([element|_contents]), do: Regex.match?(~r/^\s*(\w+)\s*((([a-zA-Z0-9-_]+="[^"]+"\s*|)*)|)\s*$/, element)
    def match?(_), do: false
    def build([element|contents], padding) do
      captured = Regex.named_captures(~r/^\s*(?<tag>\w+)\s*((?<attributes>([a-zA-Z0-9-_]+="[^"]+"\s*|)*)|)\s*$/, element)
      content  = contents |> Enum.map(&(Slim.Builder.Element.build(&1, padding + 2))) |> Enum.join
      Slim.Builder.Element.build_complex_element(captured["tag"], captured["attributes"], content, padding, true) <> Slim.Config.new_line
    end
  end

  def build_complex_element(tag, attributes, content, padding \\ 0, with_new_line \\ false) do
    attributes =  String.rstrip(attributes)
    html_element = String.duplicate(" ", padding) <> "<" <> tag
    if String.length(attributes) > 0, do: html_element = html_element <> " " <> attributes
    html_element = html_element <> ">"
    if with_new_line, do: html_element = html_element <> Slim.Config.new_line
    html_element = html_element <> content
    if with_new_line, do: html_element = html_element <> String.duplicate(" ", padding)
    html_element <> "</" <> tag <> ">"
  end
end
