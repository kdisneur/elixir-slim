defmodule Slim.EngineTest do
  use ExUnit.Case

  def test_file(path) do
   {result, _}   = Code.eval_quoted(Slim.Engine.compile(path <> ".slim", path))
   {:safe, html} = result
   assert IO.iodata_to_binary(html) == File.read!(path)
  end

  test "parse simple content", do: test_file("test/fixtures/simple_content.html")
  test "parse content with classes", do: test_file("test/fixtures/content_with_classes.html")
  test "parse nested content with classes", do: test_file("test/fixtures/nested_content_with_classes.html")
end
