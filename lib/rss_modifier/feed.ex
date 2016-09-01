defmodule RssModifier.Feed do
  alias RssModifier.Fetch
  alias RssModifier.Source

  def modify(%{"source" => source, "patterns" => patterns, "replacements" => replacements}) do
    if Source.invalid?(source) do
      {:error, :bad_request, "Source URL is invalid"}
    else
      fetch(source)
    end
  end
  def modify(_) do
    {:error, :bad_request, "Provide source, patterns and replacements"}
  end

  def fetch(source) do
    case Fetch.call(source) do
      {:ok, body} ->
        {:ok, body}
      {:error, message} ->
        {:error, :unprocessable_entity, message}
    end
  end
end
