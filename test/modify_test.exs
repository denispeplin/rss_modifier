defmodule RssModifier.ModifyTest do
  use ExUnit.Case, async: true
  alias RssModifier.Modify

  describe "call/1" do
    test "use with single modifier" do
      patterns = ["modifier"]
      replacements = ["replacement"]
      assert Modify.call("text with modifier", patterns, replacements) ==
        {:ok, "text with replacement"}
    end

    test "use with miltiple modifiers" do
      patterns = ["modifier1", "modifier2"]
      replacements = ["replacement1", "replacement2"]
      assert Modify.call("text with modifier1 and modifier2", patterns, replacements) ==
        {:ok, "text with replacement1 and replacement2"}
    end

    test "use modification sequence" do
      patterns = ["modifier", "replacement"]
      replacements = ["replacement", "some stuff"]
      assert Modify.call("text with modifier",  patterns, replacements) ==
        {:ok, "text with some stuff"}
    end
  end
end
