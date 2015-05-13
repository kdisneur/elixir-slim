defmodule Slim.Engine do
  def compile(path, name) do
    path
    |> File.read!
    |> Slim.Parser.parse
    |> Slim.Builder.build
    # |> EEx.compile_string(engine: engine_for(name), file: path, line: 1)
  end
end
