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

    test "full set of parameters, patterns number is not equal replacements number", %{params: params} do
      result = params
      |> Map.merge(%{"replacements" => ["only one replacement for two patterns"]})
      |> Params.prepare
      assert result == {:error, "Number of replacements must be equal to number of patterns"}
    end

    test "full set of parameters, patterns number is zero", %{params: params} do
      result = params
      |> Map.merge(%{"patterns" => [], "replacements" => []})
      |> Params.prepare
      assert result == {:error, "At least one modification must be specified"}
    end

    test "full set of parameters, patterns is not a list", %{params: params} do
      result = params
      |> Map.merge(%{"patterns" => "not_list"})
      |> Params.prepare
      assert result == {:error, "Patterns and replacements must be lists"}
    end

    test "full set of parameters, replacements is not a list", %{params: params} do
      result = params
      |> Map.merge(%{"replacements" => "not_list"})
      |> Params.prepare
      assert result == {:error, "Patterns and replacements must be lists"}
    end

    test "full set of parameters, patterns and replacements are not lists", %{params: params} do
      result = params
      |> Map.merge(%{"patterns" => "not_list", "replacements" => "not_list"})
      |> Params.prepare
      assert result == {:error, "Patterns and replacements must be lists"}
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
