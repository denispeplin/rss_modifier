defmodule RssModifier.FetchTest do
  use ExUnit.Case
  alias RssModifier.Fetch
  import Mock

  describe "RssModifier.Fetch.call/1" do
    test "http response :ok" do
      response = {:ok, %HTTPoison.Response{status_code: 200, body: "body"}}
      with_mock HTTPoison, [get: fn(_url) -> response end] do
        assert Fetch.call("http://example.com") == {:ok, "body"}
        assert called HTTPoison.get("http://example.com")
      end
    end

    test "http response :error, status 404" do
      response = {:ok, %HTTPoison.Response{status_code: 404}}
      with_mock HTTPoison, [get: fn(_url) -> response end] do
        assert Fetch.call("http://example.com") == {:error, "Can't get feed, it responds with 404"}
        assert called HTTPoison.get("http://example.com")
      end
    end

    test "http response :error, other status" do
      response = {:error, %HTTPoison.Error{reason: "Something wrong"}}
      with_mock HTTPoison, [get: fn(_url) -> response end] do
        assert Fetch.call("http://example.com") == {:error, "Something wrong"}
        assert called HTTPoison.get("http://example.com")
      end
    end
  end
end
