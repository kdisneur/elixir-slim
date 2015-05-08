defmodule Slim.ParserTest do
  use ExUnit.Case

  def test_file(path, expected), do: assert Slim.Parser.parse(File.read!(path)) == expected

  test "parse simple content" do
    test_file("test/fixtures/content_with_classes.html.slim",
    [[~s(div class="title" data-title="Yo" Hello World!)],
     [""]
    ])
  end

  test "parse nested content" do
    test_file("test/fixtures/nested_content_with_classes.html.slim",
    [[~s(div class="title" data-title="Yo"),
       [~s(h2 Hello World)],
       [~s(p),
         [~s(| HTML is good but...)],
         [~s(' slim is)],
         [~s(strong BETTER)]
       ]
     ],
     [~s(div),
       [~s(p class="disclaimer" That's just my humble opinion)]
     ],
     [""]
    ])
  end
end
