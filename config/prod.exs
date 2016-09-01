use Mix.Config

port = System.get_env("PORT") |> String.to_integer

config :rss_modifier, port: port
