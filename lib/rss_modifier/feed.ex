defmodule RssModifier.Feed do
  def modify(%{"source" => source, "patterns" => patterns, "replacements" => replacements}) do
    data = [source, patterns, replacements] |> inspect
    {:ok, data}
  end

  def modify(_) do
    {:error, :bad_request, "Provide source, patterns and replacements"}
  end
end
