defmodule NotificationBot.Repo.Migrations.CreateFilters do
  use Ecto.Migration

  def change do
    create table(:filters) do
      add :user_id, references(:users)
      add :link, :text
      add :is_active, :boolean

      timestamps()
    end
  end
end
