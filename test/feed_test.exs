defmodule RssModifier.FeedTest do
  use ExUnit.Case
  doctest RssModifier.Feed
  alias RssModifier.Fetch
  alias RssModifier.Feed
  import Mock

  setup do
    params = %{
      "source" => "http://example.com",
      "patterns" => ["p1", "p2"],
      "replacements" => ["r1", "r2"]
    }
    {:ok, params: params}
  end

  test "full set of parameters, fetch is :ok", %{params: params} do
    with_mock Fetch, [call: fn(_) -> {:ok, "response body"} end] do
      assert Feed.modify(params) == {:ok, "response body"}
      assert called Fetch.call(params["source"])
    end
  end

  test "full set of parameters, fetch is :error", %{params: params} do
    with_mock Fetch, [call: fn(_) -> {:error, "Something wrong"} end] do
      assert Feed.modify(params) == {:error, :unprocessable_entity, "Something wrong"}
      assert called Fetch.call(params["source"])
    end
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
