defmodule Slim.Builder do
  @default_padding 2
  @new_line        "\n"

  def build(elements), do: build(elements, 0, "")
  defp build([], _padding, results), do: results
  defp build([[""]|tail], padding, results), do: build(tail, padding, results)
  defp build([[element]|tail], padding, results) do
    aligned_element = String.duplicate(" ", padding) <> slim_to_html(element) <> @new_line
    build(tail, padding, results <> aligned_element)
  end
  defp build([[element|contents]|tail], padding, results) do
    %{
      "tag" => tag,
      "attributes" => attributes
    } = Regex.named_captures(~r/^\s*(?<tag>\w+)\s*((?<attributes>([a-zA-Z0-9-_]+="[^"]+"\s*|)*)|)\s*$/, element)
    content = build(contents, padding + @default_padding, "")

    html_element = String.duplicate(" ", padding) <> "<" <> tag
    if String.length(attributes) > 0, do: html_element = html_element <> " " <> String.rstrip(attributes)
    html_element = html_element <> ">" <> @new_line
    html_element = html_element <> content
    html_element = html_element <> String.duplicate(" ", padding) <> "</" <> tag <> ">" <> @new_line

    build(tail, padding, results <> html_element)
  end

  defp slim_to_html(slim_element) do
    [
      &build_simple_element_without_spaces/1,
      &build_simple_element_with_spaces/1,
      &build_code_evaluation_element/1,
      &build_complex_element/1
    ] |> Enum.find_value(fn function -> function.(slim_element) end)
  end

  defp build_simple_element_without_spaces(slim_element) do
    case Regex.match?(~r(^\|\s*), slim_element) do
      true -> Regex.replace(~r(^\|\s*), slim_element, "")
      _    -> nil
    end
  end

  defp build_simple_element_with_spaces(slim_element) do
    case Regex.match?(~r(^'\s*), slim_element) do
      true -> Regex.replace(~r(^'\s*), slim_element, "&nbsp;")
      _    -> nil
    end
  end

  defp build_code_evaluation_element(slim_element) do
    case Regex.match?(~r(^=\s*), slim_element) do
      true -> Regex.replace(~r(^=\s*), slim_element, "executed! ")
      _    -> nil
    end
  end

  defp build_complex_element(%{"tag" => tag, "attributes" => attributes, "content" => content}) do
    attributes = String.rstrip(attributes)

    html_element = "<" <> tag
    if String.length(attributes) > 0, do: html_element = html_element <> " " <> attributes
    html_element <> ">" <> content <> "</" <> tag <> ">"
  end
  defp build_complex_element(slim_element) do
    captured = Regex.named_captures(~r/^\s*(?<tag>\w+)\s*((?<attributes>([a-zA-Z0-9-_]+="[^"]+"\s*|)*)|)(?<content>.*)/, slim_element)
    build_complex_element(captured)
  end
end
