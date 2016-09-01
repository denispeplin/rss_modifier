defmodule RssModifier.SourceTest do
  use ExUnit.Case, async: true
  alias RssModifier.Source

  describe "invalid?/1" do
    test "valid URLs" do
      refute Source.invalid?("http://example.com")
      refute Source.invalid?("https://example.com/abc")
      refute Source.invalid?("http://example.com/abc?a=b")
    end

    test "invalid URLs" do
      assert Source.invalid?("://example.com")
      assert Source.invalid?("example.com/abc")
    end
  end
end
