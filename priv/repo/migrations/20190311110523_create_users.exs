defmodule NotificationBot.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :telegram_id, :integer
      add :first_name, :string
      add :user_name, :string
      add :date, :string

      timestamps()
    end
  end
end
