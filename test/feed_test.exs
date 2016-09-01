defmodule RssModifier.FeedTest do
  use ExUnit.Case
  doctest RssModifier.Feed
  alias RssModifier.Fetch
  alias RssModifier.Feed
  alias RssModifier.Source
  import Mock

  setup do
    params = %{
      "source" => "http://example.com",
      "patterns" => ["response", "body"],
      "replacements" => ["modified response body", "twice"]
    }
    {:ok, params: params}
  end

  test "full set of parameters, fetch is :ok", %{params: params} do
    with_mock Fetch, [call: fn(_) -> {:ok, "response body"} end] do
      assert Feed.modify(params) == {:ok, "modified response twice twice"}
      assert called Fetch.call(params["source"])
    end
  end

  test "full set of parameters, fetch is :error", %{params: params} do
    with_mock Fetch, [call: fn(_) -> {:error, "Something wrong"} end] do
      assert Feed.modify(params) == {:error, :unprocessable_entity, "Something wrong"}
      assert called Fetch.call(params["source"])
    end
  end

  test "full set of parameters, source is invalid", %{params: params} do
    with_mock Source, [invalid?: fn(_) -> true end] do
      assert Feed.modify(params) == {:error, :bad_request, "Source URL is invalid"}
      assert called Source.invalid?(params["source"])
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
