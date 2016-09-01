defmodule RssModifier.ModifyTest do
  use ExUnit.Case, async: true
  alias RssModifier.Modify

  describe "call/1" do
    test "use with single modifier" do
      modifiers = [{"modifier", "replacement"}]
      assert Modify.call("text with modifier", modifiers) == {:ok, "text with replacement"}
    end

    test "use with miltiple modifiers" do
      modifiers = [{"modifier1", "replacement1"}, {"modifier2", "replacement2"}]
      assert Modify.call("text with modifier1 and modifier2", modifiers) ==
        {:ok, "text with replacement1 and replacement2"}
    end

    test "use modification sequence" do
      modifiers = [{"modifier", "replacement"}, {"replacement", "some stuff"}]
      assert Modify.call("text with modifier", modifiers) == {:ok, "text with some stuff"}
    end
  end
end
