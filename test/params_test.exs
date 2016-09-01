defmodule RssModifier.ParamsTest do
  use ExUnit.Case, async: true
  alias RssModifier.Params

  setup do
    params = %{
      "source" => "http://example.com",
      "patterns" => ["response", "body"],
      "replacements" => ["modified response body", "twice"]
    }
    {:ok, params: params}
  end

  describe "prepare/1" do
    test "full set of parameters, source is valid", %{params: params} do
      assert Params.prepare(params) ==
        {:ok, "http://example.com", [{"response", "modified response body"}, {"body", "twice"}]}
    end

    test "full set of parameters, source is invalid", %{params: params} do
      result = params
      |> Map.merge(%{"source" => "invalid"})
      |> Params.prepare
      assert result == {:error, "Source URL is invalid"}
    end

    test "wrong params" do
      params = %{"src" => "http://example.com"}
      assert Params.prepare(params) == {:error, "Provide source, patterns and replacements"}
    end

    test "empty params" do
      params = %{}
      assert Params.prepare(params) == {:error, "Provide source, patterns and replacements"}
    end
  end
end
