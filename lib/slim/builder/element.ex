defmodule Slim.Builder.Element do
  def build(element), do: build(element, 0)
  def build(element, padding), do: find_builder(element).build(element, padding)

  defp find_builder(element) do
    [
      Slim.Builder.Element.Doctype,
      Slim.Builder.Element.SimpleTextWithoutSpaces,
      Slim.Builder.Element.SimpleTextWithSpaces,
      Slim.Builder.Element.EvaluatedElement,
      Slim.Builder.Element.AutoClosingTags,
      Slim.Builder.Element.MultilineTag,
      Slim.Builder.Element.MonolineTag
    ] |> Enum.find(&(&1.match?(element)))
  end

  defmodule Doctype do
    def match?([element]), do: Regex.match?(~r(^doctype ), element)
    def match?(_), do: false
    def build([element], padding) do
      case Regex.replace(~r/^(doctype\s+)/, element, "") do
        doctype when doctype == "html" or doctype == 5 -> ~s(<!DOCTYPE html>)
        doctype when doctype == "1.1" -> ~s(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">)
        doctype when doctype == "strict" -> ~s(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">)
        doctype when doctype == "frameset" -> ~s(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">)
        doctype when doctype == "mobile" -> ~s(<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">)
        doctype when doctype == "basic" -> ~s(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">)
        doctype when doctype == "transitional" -> ~s(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">)
      end <> Slim.Config.new_line
    end
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

  defmodule AutoClosingTags do
    def match?([element|tail]), do: Regex.match?(~r/^\s*(br|hr|img|input|meta)\s*((([a-zA-Z0-9-_]+="[^"]+"\s*|)*)|)\s*/, element)
    def match?(_), do: false
    def build([element], padding) do
      captured = Regex.named_captures(~r/^\s*(?<tag>\w+)\s*((?<attributes>([a-zA-Z0-9-_]+="[^"]+"\s*|)*)|)\s*/, element)
      html_element = String.duplicate(" ", padding) <> "<" <> captured["tag"]
      if String.length(captured["attributes"]) > 0, do: html_element = html_element <> " " <> String.lstrip(captured["attributes"])
      html_element <> ">" <> Slim.Config.new_line
    end
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
