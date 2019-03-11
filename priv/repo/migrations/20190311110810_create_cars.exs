defmodule NotificationBot.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars) do
      add :filter_id, references(:filters)
      add :number, :string
      add :price, :integer
      add :price_brutto, :integer
      add :price_detail, :string
      add :currency, :string
      add :year, :string
      add :mileage, :string
      add :engine_capacity, :string
      add :fuel_type, :string
      add :location, :string
      add :subtitle, :string
      add :link, :text

      timestamps()
    end

  end
end
