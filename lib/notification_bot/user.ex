defmodule NotificationBot.User do
  use Ecto.Schema

  schema "users" do
    field :telegram_id, :integer
    field :first_name, :string
    field :user_name, :string
    field :date, :string

    has_many :filters, NotificationBot.Filter

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:telegram_id, :user_name, :first_name, :date])
    |> Ecto.Changeset.validate_required([:telegram_id, :user_name, :first_name, :date])
  end
end