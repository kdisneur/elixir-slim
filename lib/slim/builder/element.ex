defmodule Slim.Builder.Element do
  def build(element), do: build(element, 0)
  def build(element, padding), do: find_builder(element).build(element, padding)

  defp find_builder(element) do
    [
      Slim.Builder.Element.Doctype,
      Slim.Builder.Element.SimpleTextWithSpaces,
      Slim.Builder.Element.SimpleTextWithoutSpaces,
      Slim.Builder.Element.EvaluatedElementWithSpaces,
      Slim.Builder.Element.EvaluatedElementWithoutSpaces,
      Slim.Builder.Element.AutoClosingTags,
      Slim.Builder.Element.MultilineTag,
      Slim.Builder.Element.MonolineTag
    ] |> Enum.find(&(&1.match?(element)))
  end
end
