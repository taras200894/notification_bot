defmodule NotificationBot.User do
  use Ecto.Schema

  alias NotificationBot.User

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

  def create_user_from_telegram(msg) do
    user_params = %{
      date: "#{msg.date}",
      first_name: msg.chat.first_name,
      user_name: msg.chat.username,
      telegram_id: msg.chat.id
    }

    changeset = User.changeset(%User{}, user_params)

    insert_or_find_user(changeset)
  end

  defp insert_or_find_user(changeset) do
    case NotificationBot.Repo.get_by(User, telegram_id: changeset.changes.telegram_id) do
      nil ->
        NotificationBot.Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end