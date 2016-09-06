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

  describe "check/1" do
    test "full set of parameters, source is valid", %{params: params} do
      assert Params.check(params) == nil
    end

    test "full set of parameters, source is invalid", %{params: params} do
      result = params
      |> Map.merge(%{"source" => "invalid"})
      |> Params.check
      assert result == {:error, "Source URL is invalid"}
    end

    test "full set of parameters, patterns number is not equal replacements number", %{params: params} do
      result = params
      |> Map.merge(%{"replacements" => ["only one replacement for two patterns"]})
      |> Params.check
      assert result == {:error, "Number of replacements must be equal to number of patterns"}
    end

    test "full set of parameters, patterns number is zero", %{params: params} do
      result = params
      |> Map.merge(%{"patterns" => [], "replacements" => []})
      |> Params.check
      assert result == {:error, "At least one modification must be specified"}
    end

    test "full set of parameters, patterns is not a list", %{params: params} do
      result = params
      |> Map.merge(%{"patterns" => "not_list"})
      |> Params.check
      assert result == {:error, "Patterns and replacements must be lists"}
    end

    test "full set of parameters, replacements is not a list", %{params: params} do
      result = params
      |> Map.merge(%{"replacements" => "not_list"})
      |> Params.check
      assert result == {:error, "Patterns and replacements must be lists"}
    end

    test "full set of parameters, patterns and replacements are not lists", %{params: params} do
      result = params
      |> Map.merge(%{"patterns" => "not_list", "replacements" => "not_list"})
      |> Params.check
      assert result == {:error, "Patterns and replacements must be lists"}
    end

    test "wrong params" do
      params = %{"src" => "http://example.com"}
      assert Params.check(params) == {:error, "Provide a source"}
    end

    test "empty params" do
      params = %{}
      assert Params.check(params) == {:error, "Provide a source"}
    end

    test "only source provided" do
      params = %{"source" => "http://example.com"}
      assert Params.check(params) ==
        {:error, "Provide a source and either modifiers (patterns + replacement) or a filter"}
    end

    test "filter is not a string" do
      params = %{"source" => "http://example.com", "filter" => []}
      assert Params.check(params) == {:error, "Filter must be a string"}
    end
  end
end
