defmodule RssModifier.Params do
  alias RssModifier.Source

  # TODO: rewrite using https://github.com/CargoSense/vex
  def check(params) do
    with nil <- check_source(params),
         nil <- check_required_params(params),
         nil <- check_modifiers(params),
         nil <- check_filter(params),
      do: nil
  end

  defp check_source(%{"source" => url}) do
    if Source.invalid?(url) do
      {:error, "Source URL is invalid"}
    end
  end
  defp check_source(_) do
    {:error, "Provide a source"}
  end

  defp check_required_params(%{"patterns" => _, "replacements" => _}), do: nil
  defp check_required_params(%{"filter" => _}), do: nil
  defp check_required_params(_) do
    {:error, "Provide a source and either modifiers (patterns + replacement) or a filter"}
  end

  defp check_modifiers(%{"patterns" => patterns, "replacements" => replacements}) when is_list(patterns) and is_list(replacements) do
      # TODO: cleanup patterns and replacements, remove empty values before check
      cond do
        length(patterns) != length(replacements) ->
          {:error, "Number of replacements must be equal to number of patterns"}
        Enum.empty?(patterns) ->
          {:error, "At least one modification must be specified"}
        true ->
          nil
      end
  end
  defp check_modifiers(%{"patterns" => _, "replacements" => _}) do
    {:error, "Patterns and replacements must be lists"}
  end
  defp check_modifiers(_), do: nil

  defp check_filter(%{"filter" => filter}) when is_binary(filter), do: nil
  defp check_filter(%{"filter" => _}) do
    {:error, "Filter must be a string"}
  end
  defp check_filter(_), do: nil
end
