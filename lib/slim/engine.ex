defmodule Slim.Engine do
  def compile(path, _name) do
    path
    |> File.read!
    |> Slim.Parser.parse
    |> Slim.Builder.build
    |> EEx.compile_string(engine: Phoenix.HTML.Engine, file: path, line: 1)
  end
end
