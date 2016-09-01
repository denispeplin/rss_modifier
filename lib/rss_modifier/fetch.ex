defmodule RssModifier.Fetch do
  def call(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Can't get feed, it responds with #{status_code}"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason |> parse_reason}
    end
  end

  defp parse_reason(reason) when is_binary(reason) do
    reason
  end
  defp parse_reason(reason) do
    reason |> inspect
  end
end
