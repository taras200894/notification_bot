# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :notification_bot,
       token: "418662565:AAEsq7ZNj1Xg-A6wJ5kw0Bvn2LhNZDKrmSM"

config :notification_bot,
       ecto_repos: [NotificationBot.Repo]

config :notification_bot,
       NotificationBot.Repo,
       database: "ab8d14bd-f939-4b4b-88bd-1e829bd4fdd6",
       username: "ab8d14bd-f939-4b4b-88bd-1e829bd4fdd6-user",
       password: "pw-7a678d97-c50f-4372-88e4-3b9aa8df93fd",
       hostname: "postgres-free-tier-1.gigalixir.com",
       port: 5432

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :notification_bot, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:notification_bot, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
