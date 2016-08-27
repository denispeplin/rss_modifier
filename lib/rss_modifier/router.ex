defmodule RssModifier.Router do
  use Plug.Router

  #if Mix.env == :dev do
  #  use Plug.Debugger
  #end

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Hello World!")
  end
end
