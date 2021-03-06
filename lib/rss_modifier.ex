defmodule RssModifier do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:rss_modifier, :port)

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, RssModifier.Router, [], [port: port])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RssModifier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
