defmodule RssModifier.Feed do
  alias RssModifier.Fetch

  def modify(%{"source" => source, "patterns" => patterns, "replacements" => replacements}) do
    case Fetch.call(source) do
      {:ok, body} ->
        {:ok, body}
      {:error, message} ->
        {:error, :unprocessable_entity, message}
    end
  end

  def modify(_) do
    {:error, :bad_request, "Provide source, patterns and replacements"}
  end
end
