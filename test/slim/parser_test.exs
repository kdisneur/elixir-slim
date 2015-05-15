defmodule Slim.ParserTest do
  use ExUnit.Case

  def test_file(path, expected), do: assert Slim.Parser.parse(File.read!(path)) == expected

  test "parse simple content" do
    test_file("test/fixtures/content_with_classes.html.slim",
    [[~s(div class="title" data-title="Yo" Hello World!)]])
  end

  test "parse nested content" do
    test_file("test/fixtures/nested_content_with_classes.html.slim",
    [[~s(doctype html)],
     [~s(div class="title" data-title="Yo \#{40 + 2}"),
       [~s(h2 Hello World)],
       [~s(p),
         [~s(| HTML is good but...)],
         [~s(br)],
         [~s(' slim is \#{ "rea" <> "lly" })],
         [~s(strong BETTER)]
       ]
     ],
     [~s(hr class="my-class")],
     [~s(div class="disclaimer"),
       [~s(p class="disclaimer" That's just my humble opinion)],
       [~s(ul),
         [~s(li id="first" First)],
         [~s(li id="second" Second)],
         [~s(li),
           [~s(| Maths are hard. 1 + 1 =)],
           [~s(= 1 + 1)]
         ],
         [~s(li),
           [~s(| Maths are nice with more spaces:)],
           [~s(=' 191 * 7)]
         ]
       ],
       [~s(div class="nested1"),
         [~s(div class="nested2"),
           [~s(a href="link"),
             [~s(| Click to enlarge)]
           ]
         ]
       ],
       [~s(span Here we are)]
     ],
     [~s(footer The end)],
     [~s(script src="\#{"/js/app.js"}")]
    ])
  end
end
