defmodule RssModifier.Router do
  use Plug.Router

  if Mix.env == :dev do
    use Plug.Debugger
  end

  if Mix.env != :test do
    plug Plug.Logger
  end

  plug :fetch_query_params
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, :ok, "Reserved for a front page")
  end

  get "/modify" do
    case RssModifier.Feed.call(conn.params) do
      {:ok, feed} ->
        send_resp(conn, :ok, feed)
      {:error, code, message} ->
        send_resp(conn, code, message)
    end
  end

  match _ do
    send_resp(conn, :not_found, "Path not found.")
  end
end
