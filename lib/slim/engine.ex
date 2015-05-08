defmodule Slim.Engine do
  def compile(path, _final_name), do: File.read!(path) |> Slim.Parser.parse |> Slim.Builder.build
end
