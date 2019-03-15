defmodule NotificationBot do
  use Application

  require Logger

  import Supervisor.Spec

  def start(_type, _args) do
    token = Telex.Config.get(:notification_bot, :token)

    children = [
      NotificationBot.Repo,
      supervisor(Telex, []),
      supervisor(NotificationBot.Bot, [:polling, token]),
      worker(NotificationBot.Periodically, [])
    ]

    opts = [strategy: :one_for_one, name: NotificationBot]

    case Supervisor.start_link(children, opts) do
      {:ok, _} = ok ->
        Logger.info("Starting NiceBot")
        ok
      error ->
        Logger.error("Error starting NiceBot")
        error
    end
  end
end
