defmodule RssModifier.FeedTest do
  use ExUnit.Case, async: true
  doctest RssModifier.Feed
  alias RssModifier.Feed

  test "full set of parameters" do
    params = %{
      "source" => "http://example.com",
      "patterns" => ["p1", "p2"],
      "replacements" => ["r1", "r2"]
    }
    assert {:ok, "[\"http://example.com\", [\"p1\", \"p2\"], [\"r1\", \"r2\"]]"} =
      Feed.modify(params)
  end

  test "wrong params" do
    params = %{"src" => "http://example.com"}
    assert {:error, :bad_request, "Provide source, patterns and replacements"} =
      Feed.modify(params)
  end

  test "empty params" do
    params = %{}
    assert {:error, :bad_request, "Provide source, patterns and replacements"} =
      Feed.modify(params)
  end
end
