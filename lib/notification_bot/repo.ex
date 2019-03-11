defmodule NotificationBot.Repo do
  use Ecto.Repo,
      otp_app: :notification_bot,
      adapter: Ecto.Adapters.Postgres
end
