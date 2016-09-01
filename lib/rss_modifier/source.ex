defmodule RssModifier.Source do
  def invalid?(url), do: !valid?(url)

  defp valid?(url) do
    case URI.parse(url) do
      %URI{scheme: nil} -> false
      %URI{host: nil, path: nil} -> false
      _ -> true
    end
  end
end
