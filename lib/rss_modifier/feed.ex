defmodule RssModifier.Feed do
  alias RssModifier.Fetch
  alias RssModifier.Source
  alias RssModifier.Modify

  def modify(%{"source" => url, "patterns" => patterns, "replacements" => replacements}) do
    modifiers = List.zip [patterns, replacements]
    if Source.invalid?(url) do
      {:error, :bad_request, "Source URL is invalid"}
    else
      fetch(url) |> modify(modifiers)
    end
  end
  def modify(_) do
    {:error, :bad_request, "Provide source, patterns and replacements"}
  end

  defp fetch(url) do
    case Fetch.call(url) do
      {:ok, body} ->
        {:ok, body}
      {:error, message} ->
        {:error, :unprocessable_entity, message}
    end
  end

  defp modify({:ok, source}, modifiers) do
    Modify.call(source, modifiers)
  end
  defp modify(error, _) do
    error
  end
end
