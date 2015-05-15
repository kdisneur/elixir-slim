defmodule Slim.Builder.Element.HelperTest do
  use ExUnit.Case

  test "split_attributes_and_content/1 with simple attributes and content" do
    result = Slim.Builder.Element.Helper.split_attributes_and_content(~s(class="btn btn-default" id="12" Hello 1 + 1 = "2" !))
    assert result == {[~s(class="btn btn-default"), ~s(id="12")], ~s(Hello 1 + 1 = "2" !)}
  end

  test "split_attributes_and_content/1 with simple attributes and no content" do
    result = Slim.Builder.Element.Helper.split_attributes_and_content(~s(class="btn btn-default" id="12"))
    assert result == {[~s(class="btn btn-default"), ~s(id="12")], ~s()}
  end

  test "split_attributes_and_content/1 with no attributes and content" do
    result = Slim.Builder.Element.Helper.split_attributes_and_content(~s(Hello 1 + 1 = "2" !))
    assert result == {[], ~s(Hello 1 + 1 = "2" !)}
  end

  test "split_attributes_and_content/1 with no attributes and no content" do
    result = Slim.Builder.Element.Helper.split_attributes_and_content(~s())
    assert result == {[], ~s()}
  end

  test "split_attributes_and_content/1 with no attributes and interpolated content" do
    result = Slim.Builder.Element.Helper.split_attributes_and_content(~s(class="btn btn-default" id="\#{40 + 2}" Hello 1 + 1 = "2" !))
    assert result == {[~s(class="btn btn-default"), ~s(id="\#{40 + 2}")], ~s(Hello 1 + 1 = "2" !)}
  end
end
