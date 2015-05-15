defmodule Slim.Builder.Element.IfElementTest do
  use ExUnit.Case

  test "build/2 a if without else" do
    result = Slim.Builder.Element.IfElement.build([
      ~s(- if 1 == 1 do),
        [~s(| Hello)],
        [~s(' world)],
    ], 0)
    assert result == ~s(<%= if 1 == 1 do %>Hello
&nbsp;world
<% end %>)
  end
end
