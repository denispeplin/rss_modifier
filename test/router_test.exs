defmodule RssModifier.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest RssModifier.Feed
  import Mock
  alias RssModifier.Feed
  alias RssModifier.Router

  @opts RssModifier.Router.init([])

  test "calls front page" do
    conn = conn(:get, "/")
    conn = Router.call(conn, @opts)
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Reserved for a front page"
  end

  test "calls Feed and retuns result" do
    conn = conn(:get, "/modify?src=abc")

    with_mock Feed, [call: fn(_params) -> {:ok, "feed contents"} end] do
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == "feed contents"
      assert called Feed.call(%{"src" => "abc"})
    end
  end

  test "calls Feed and retuns error" do
    conn = conn(:get, "/modify?wrong=parameter")

    with_mock Feed, [call: fn(_params) -> {:error, 400, "message"} end] do
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 400
      assert conn.resp_body == "message"
      assert called Feed.call(%{"wrong" => "parameter"})
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
