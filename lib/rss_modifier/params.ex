defmodule RssModifier.Params do
  alias RssModifier.Source

  def prepare(%{"source" => url, "patterns" => patterns, "replacements" => replacements}) do
    modifiers = List.zip [patterns, replacements]
    cond do
      Source.invalid?(url) ->
        {:error, "Source URL is invalid"}
      true ->
        {:ok, url, modifiers}
    end
  end
  def prepare(_) do
    {:error, "Provide source, patterns and replacements"}
  end
end
