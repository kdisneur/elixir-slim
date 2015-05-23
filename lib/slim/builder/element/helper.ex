defmodule Slim.Builder.Element.Helper do
  def build_complex_element(tag, attributes, content, padding \\ 0, with_new_line \\ false) do
    attributes =  Slim.Builder.Element.Helper.interpolate_content(attributes |> Enum.join(" "))
    html_element = String.duplicate(" ", padding) <> "<" <> tag
    if String.length(attributes) > 0, do: html_element = html_element <> " " <> attributes
    html_element = html_element <> ">"
    if with_new_line, do: html_element = html_element <> Slim.Config.new_line
    html_element = html_element <> content
    if with_new_line, do: html_element = html_element <> String.duplicate(" ", padding)
    html_element <> "</" <> tag <> ">"
  end

  def interpolate_content(content), do: Regex.replace(~r/#\{([^\}]*)\}/, content, "<%= \\1 %>")

  def split_attributes_and_content(raw_content), do: split_attributes_and_content(raw_content, {[], ""})
  defp split_attributes_and_content("", result), do: result
  defp split_attributes_and_content(raw_content, {current_attributes, current_content}) do
    case Regex.named_captures(~r/^\s*(?<attribute_name>[a-zA-Z0-9_-]+)="/, raw_content) do
      %{"attribute_name" => attribute_name} ->
        {attribute_value, raw_content} = find_end_of_attribute(take_prefix(String.lstrip(raw_content), ~s(#{attribute_name}=")))
        split_attributes_and_content(raw_content, {current_attributes ++ [~s(#{attribute_name}="#{attribute_value}")], current_content})
      _ -> {current_attributes, String.strip(raw_content)}
    end
  end

  defp take_prefix(full, prefix) do
    base = String.length(prefix)
    String.slice(full, base, String.length(full) - base)
  end

  defp find_end_of_attribute(""), do: {"", ""}
  defp find_end_of_attribute(raw_content) do
    %{ "basic_value" => value } = Regex.named_captures(~r/^(?<basic_value>[^"]+)/, raw_content)
    case String.contains?(value, ~s(\#{)) do
      true  -> find_end_of_interpolated_attribute(raw_content)
      false -> {value, take_prefix(raw_content, ~s(#{value}"))}
    end
  end

  defp find_end_of_interpolated_attribute(raw_content), do: find_end_of_interpolated_attribute(raw_content, 0, "")
  defp find_end_of_interpolated_attribute("", _padding, result), do: {result, ""}
  defp find_end_of_interpolated_attribute("\"" <> raw_content, 0, result), do: {result, raw_content}
  defp find_end_of_interpolated_attribute(~s(\#{) <> raw_content, padding, result), do: find_end_of_interpolated_attribute(raw_content, padding + 1, result <> ~s(\#{))
  defp find_end_of_interpolated_attribute(~s(}) <> raw_content, padding, result), do: find_end_of_interpolated_attribute(raw_content, padding - 1, result <> ~s(}))
  defp find_end_of_interpolated_attribute(raw_content, padding, result), do: find_end_of_interpolated_attribute(String.slice(raw_content, 1, String.length(raw_content) - 1), padding, result <> String.first(raw_content))
end
