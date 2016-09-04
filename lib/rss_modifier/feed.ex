defmodule RssModifier.Feed do
  alias RssModifier.Fetch
  alias RssModifier.Modify
  alias RssModifier.Params

  def call(params) do
    case Params.prepare(params) do
      {:error, message} ->
        {:error, :bad_request, message}
      {:ok, url, modifiers} ->
        fetch(url) |> filter |> modify(modifiers)
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

  defp filter({:ok, feed}) do
    {:ok, RssFlow.filter(feed, "Elixir")}
  end
  defp filter({:error, _, _} = error), do: error

  defp modify({:ok, source}, modifiers) do
    Modify.call(source, modifiers)
  end
  defp modify({:error, _, _} = error, _), do: error
end
