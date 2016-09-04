ExUnit.start()

defmodule ExUnit.TestHelpers do
  def read_rss(filename) do
    System.cwd
    |> Path.join("test/files/#{filename}.rss")
    |> File.read
  end
  def read_rss!(filename) do
    case read_rss(filename) do
      {:ok, binary} ->
        binary
      {:error, reason} ->
        raise File.Error, reason: reason, action: "read file",
          path: IO.chardata_to_string(filename)
    end
  end
end
