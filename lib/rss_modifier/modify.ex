defmodule RssModifier.Modify do
  def call(source, [modifier | tail]) do
    source
    |> do_modify(modifier)
    |> call(tail)
  end
  def call(source, []), do: {:ok, source}

  defp do_modify(source, {pattern, replacement}) do
    source
    |> String.replace(pattern, replacement)
  end
end
