defmodule RssModifier.FeedTest do
  use ExUnit.Case
  doctest RssModifier.Feed
  alias RssModifier.Fetch
  alias RssModifier.Feed
  alias RssModifier.Params
  import Mock
  import ExUnit.TestHelpers, only: [read_rss: 1, read_rss!: 1]

  setup do
    params = %{
      "source" => "http://example.com",
      "patterns" => ["world", "Onsite"],
      "replacements" => ["this country", "Remote"],
      "filter" => "Elixir"
    }
    {:ok, params: params}
  end

  test "full set of parameters, fetch is :ok", %{params: params} do
    with_mock Fetch, [call: fn(_) -> read_rss("jobs_feed") end] do
      {:ok, feed} = Feed.call(params)
      assert RssFlow.parse(feed) == RssFlow.parse(read_rss!("jobs_feed_elixir_modified"))
      assert called Fetch.call(params["source"])
    end
  end

  test "full set of parameters, fetch is :ok, no filter", %{params: params} do
    with_mock Fetch, [call: fn(_) -> read_rss("jobs_feed") end] do
      {:ok, feed} = Feed.call(Map.delete(params, "filter"))
      assert RssFlow.parse(feed) == RssFlow.parse(read_rss!("jobs_feed_modified"))
      assert called Fetch.call(params["source"])
    end
  end

  test "full set of parameters, fetch is :error", %{params: params} do
    with_mock Fetch, [call: fn(_) -> {:error, "Something wrong"} end] do
      assert Feed.call(params) == {:error, :unprocessable_entity, "Something wrong"}
      assert called Fetch.call(params["source"])
    end
  end

  test "full set of parameters, source is invalid", %{params: params} do
    with_mock Params, [check: fn(_) -> {:error, "Error preparing parameters"} end] do
      assert Feed.call(params) == {:error, :bad_request, "Error preparing parameters"}
      assert called Params.check(params)
    end
  end
end
