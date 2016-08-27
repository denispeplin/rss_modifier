defmodule RssModifier.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest RssModifier

  @opts RssModifier.Router.init([])

  test "returns hello world" do
    # Create a test connection
    conn = conn(:get, "/")

    # Invoke the plug
    conn = RssModifier.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello World!"
  end
end
