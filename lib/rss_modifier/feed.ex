defmodule RssModifier.Feed do
  alias RssModifier.Fetch
  alias RssModifier.Modify
  alias RssModifier.Params

  def call(params) do
    case Params.check(params) do
      {:error, message} ->
        {:error, :bad_request, message}
      _ ->
        fetch(params["source"])
        |> filter(params["filter"])
        |> modify(params["patterns"], params["replacements"])
    end
  end

  defp fetch(url) do
    case Fetch.call(url) do
      {:ok, body} ->
        {:ok, body}
      {:error, message} ->
        {:error, :unprocessable_entity, message}
    end
  end

  defp filter({:ok, feed}, nil), do: {:ok, feed}
  defp filter({:ok, feed}, filter) do
    {:ok, RssFlow.filter(feed, filter)}
  end
  defp filter({:error, _, _} = error, _), do: error

  defp modify({:ok, source}, patterns, replacements) do
    Modify.call(source, patterns, replacements)
  end
  defp modify({:error, _, _} = error, _, _), do: error
end
