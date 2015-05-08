defmodule Slim.EngineTest do
  use ExUnit.Case

  def test_file(path), do: assert Slim.Engine.compile(path <> ".slim", path) == File.read!(path)

  test "parse simple content", do: test_file("test/fixtures/simple_content.html")
  test "parse content with classes", do: test_file("test/fixtures/content_with_classes.html")
  test "parse nested content with classes", do: test_file("test/fixtures/nested_content_with_classes.html")
end
