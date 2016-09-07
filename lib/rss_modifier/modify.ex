defmodule RssModifier.Modify do
  def call(source, nil, nil), do: source
  def call(source, patterns, replacements) do
    modifiers = List.zip [patterns, replacements]
    run_modifiers(source, modifiers)
  end

  defp run_modifiers(source, [modifier | tail]) do
    source
    |> do_modify(modifier)
    |> run_modifiers(tail)
  end
  defp run_modifiers(source, []), do: {:ok, source}

  defp do_modify(source, {pattern, replacement}) do
    source
    |> String.replace(pattern, replacement)
  end
end
