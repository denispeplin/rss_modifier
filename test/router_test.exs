defmodule RssModifier.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest RssModifier.Feed
  import Mock
  alias RssModifier.Feed
  alias RssModifier.Router

  @opts RssModifier.Router.init([])

  test "calls Feed and retuns result" do
    conn = conn(:get, "/?src=abc")

    with_mock Feed, [modify: fn(_params) -> {:ok, "feed contents"} end] do
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == "feed contents"
      assert called Feed.modify(%{"src" => "abc"})
    end
  end

  test "calls Feed and retuns error" do
    conn = conn(:get, "/?wrong=parameter")

    with_mock Feed, [modify: fn(_params) -> {:error, 400, "message"} end] do
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 400
      assert conn.resp_body == "message"
      assert called Feed.modify(%{"wrong" => "parameter"})
    end
  end

  test "returns 404 for missing paths" do
    conn = conn(:get, "/missing_path")

    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "Path not found."
  end
end
