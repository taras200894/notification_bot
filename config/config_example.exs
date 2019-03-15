use Mix.Config

config :notification_bot,
       token: {:system, "DAILY_BOT_TOKEN"}

config :notification_bot,
       ecto_repos: [NotificationBot.Repo]

config :notification_bot,
       NotificationBot.Repo,
       database: "database",
       username: "username",
       password: "password",
       hostname: "hostname"
