defmodule Slim.Engine do
  @behaviour Phoenix.Template.Engine

  def compile(path, name) do
    path
    |> File.read!
    |> Slim.Parser.parse
    |> Slim.Builder.build
    |> EEx.compile_string(engine: Phoenix.HTML.Engine, file: path, line: 1)
  end
end
