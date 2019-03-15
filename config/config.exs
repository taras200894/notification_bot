use Mix.Config

config :notification_bot,
       token: "418662565:AAEsq7ZNj1Xg-A6wJ5kw0Bvn2LhNZDKrmSM"

config :notification_bot,
       ecto_repos: [NotificationBot.Repo]

config :notification_bot,
       NotificationBot.Repo,
       database: "notification_bot_repo",
       username: "taras",
       password: "taras",
       hostname: "localhost"