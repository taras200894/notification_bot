defmodule NotificationBot.Filter do
  use Ecto.Schema

  schema "filters" do
    field :link, :string
    field :is_active, :boolean

    belongs_to :user, NotificationBot.User
    has_many :cars, NotificationBot.Car

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:user_id, :link, :is_active])
    |> Ecto.Changeset.validate_required([:user_id, :link, :is_active])
  end

end