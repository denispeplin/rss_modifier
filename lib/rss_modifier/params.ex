defmodule RssModifier.Params do
  alias RssModifier.Source

  def prepare(%{"source" => url, "patterns" => patterns, "replacements" => replacements})
    when is_list(patterns) and is_list(replacements) do
    cond do
      Source.invalid?(url) ->
        {:error, "Source URL is invalid"}
      length(patterns) != length(replacements) ->
        {:error, "Number of replacements must be equal to number of patterns"}
      Enum.empty?(patterns) ->
        {:error, "At least one modification must be specified"}
      true ->
        # TODO: cleanup patterns and replacements, remove empty values
        modifiers = List.zip [patterns, replacements]
        {:ok, url, modifiers}
    end
  end
  def prepare(%{"source" => _, "patterns" => patterns, "replacements" => replacements}) do
    {:error, "Patterns and replacements must be lists"}
  end
  def prepare(_) do
    {:error, "Provide source, patterns and replacements"}
  end
end
