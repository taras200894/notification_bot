defmodule NotificationBot.Car do
  use Ecto.Schema

  schema "cars" do
    field :number, :string
    field :price, :integer
    field :price_brutto, :integer
    field :price_detail, :string
    field :currency, :string
    field :year, :string
    field :mileage, :string
    field :engine_capacity, :string
    field :fuel_type, :string
    field :location, :string
    field :subtitle, :string
    field :link, :string

    belongs_to :filter, NotificationBot.Filter

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params,
         [
           :number,
           :price,
           :price_brutto,
           :price_detail,
           :currency,
           :year,
           :mileage,
           :engine_capacity,
           :fuel_type,
           :location,
           :subtitle,
           :link,
           :filter_id
         ]
       )
    |> Ecto.Changeset.validate_required(
         [
           :number,
           :price,
           :price_brutto,
           :price_detail,
           :currency,
           :year,
           :mileage,
           :engine_capacity,
           :fuel_type,
           :location,
           :subtitle,
           :link,
           :filter_id
         ]
       )
  end
end