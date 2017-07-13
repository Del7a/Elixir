# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :hello_phoenix,
  ecto_repos: [HelloPhoenix.Repo],
  initial_capital: 1000

# Configures the endpoint
config :hello_phoenix, HelloPhoenix.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Z9LM1vaTU60H3MBOtQAVToA7uQ+5tAPY/V3ONGGUH1gU3BTVLwb2h1psjDPBwKas",
  render_errors: [view: HelloPhoenix.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HelloPhoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures the Mnesia database
config :ecto_mnesia,
  host: {:system, :atom, "MNESIA_HOST", Kernel.node()},
  storage_type: {:system, :atom, "MNESIA_STORAGE_TYPE", :disc_copies}

config :mnesia,
  dir: '/home/philip/hello_phoenix/mnesia' # Make sure this directory exists otherwise it blows up!

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian Serealizer for user identification
config :guardian, Guardian,
 issuer: "HelloPhoenix.#{Mix.env}",
 ttl: {30, :days},
 verify_issuer: true,
 serializer: HelloPhoenix.GuardianSerializer,
 secret_key: to_string(Mix.env) <> "SuPerseCret_aBraCadabrA"

  config :guardian_db, GuardianDb,
  repo: HelloPhoenix.Repo,
  sweep_interval: 60 # 60 minutes


  config :ueberauth, Ueberauth,
    providers: [
      identity: {Ueberauth.Strategy.Identity, [callback_methods: ["POST"]]},
    ]


config :finance,
  request_interval: 60000,
  usd_to_eur_request_url: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DUSDEUR%3DX%22%3B&format=json&diagnostics=true&callback=",
  gold_to_usd_request_url: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DXAUUSD%3DX%22%3B&format=json&diagnostics=true&callback="


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
