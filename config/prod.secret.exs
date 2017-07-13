use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :hello_phoenix, HelloPhoenix.Endpoint,
  secret_key_base: "DGIlG2LyT1V0ANtKRWJa6dFh0dp/hc4njxTxIRbN5yu5XUpsBjQV44nnhz2jbHfe"

# Configure your database
config :hello_phoenix, HelloPhoenix.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "hello_phoenix_prod",
  pool_size: 20
