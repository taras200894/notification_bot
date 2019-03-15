defmodule NotificationBot.Filter do
  use Ecto.Schema

  alias NotificationBot.Filter

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

  def create_filter_from_telegram(t, id) do
    user = NotificationBot.Repo.get_by(NotificationBot.User, telegram_id: id)

    filter_params = %{
      link: t,
      user_id: user.id,
      is_active: true
    }

    changeset = Filter.changeset(%Filter{}, filter_params)

    insert_or_update_filter(changeset)
  end

  defp insert_or_update_filter(changeset) do
    case NotificationBot.Repo.get_by(
           Filter,
           user_id: changeset.changes.user_id,
           link: changeset.changes.link,
           is_active: changeset.changes.is_active
         ) do
      nil ->
        NotificationBot.Repo.insert(changeset)
      filter ->
        {:ok, filter}
    end
  end

  def format_list(filters) do
    case filters do
      [] ->
        List.foldr([], [], fn x, acc -> [[[text: x.link, callback_data: "del:elem:#{x.id}"]] | acc] end)
        |> (fn x -> x ++ [[[text: "Done", callback_data: "del:done"]]] end).()
        |> Buttons.create_inline
      filter_list ->
        List.foldr(filter_list, [], fn x, acc -> [[[text: x.link, callback_data: "del:elem:#{x.id}"]] | acc] end)
        |> (fn x -> x ++ [[[text: "Done", callback_data: "del:done"]]] end).()
        |> Buttons.create_inline
    end
  end
end