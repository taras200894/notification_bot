defmodule NotificationBot.Bot do
  @bot_name :notification_bot
  def bot(), do: @bot_name

  use Telex.Bot, name: @bot_name
  use Telex.Dsl

  alias NotificationBot.User
  alias NotificationBot.Filter

  def handle({:command, "start", msg}, _name, _extra) do
    user_params = %{
      date: "#{msg.date}",
      first_name: msg.chat.first_name,
      user_name: msg.chat.username,
      telegram_id: msg.chat.id
    }

    changeset = User.changeset(%User{}, user_params)

    {_, user} = insert_or_update_user(changeset)

#    Telex.send_message(user.telegram_id, "raasd", bot: :notification_bot)

    answer("Hello #{user.first_name}!")
  end

  def handle({:command, "create_filter", msg}, _name, _extra) do
    user = NotificationBot.Repo.get_by(User, telegram_id: "#{msg.chat.id}")

    filter_params = %{
      link: msg.text,
      user_id: user.id,
      is_active: true
    }

    changeset = Filter.changeset(%Filter{}, filter_params)

    IO.inspect(filter_params)
    insert_or_update_filter(changeset)
  end

#  def handle({:command, "remove_filter", msg}, _name, _extra) do
#    IO.inspect(msg)
#    user = NotificationBot.Repo.get_by(User, telegram_id: "#{msg.chat.id}")
#
#    filter_params = %{
#      link: msg.text,
#      user_id: user.id,
#      is_active: true
#    }
#
#    changeset = Filter.changeset(%Filter{}, filter_params)
#
#    IO.inspect(filter_params)
#    insert_or_update_filter(changeset)
#  end

#  defp generate_string_response(car) do
#    response = Enum.map(car, fn {a, i} -> "#{Atom.to_string(a)}: #{i}" end)
#
#    Enum.join(response, ", ")
#  end

  defp insert_or_update_filter(changeset) do
    case NotificationBot.Repo.get_by(
           Filter, user_id: changeset.changes.user_id,
           link: changeset.changes.link,
           is_active: changeset.changes.is_active
         ) do
      nil ->
        NotificationBot.Repo.insert(changeset)
      filter ->
        {:ok, filter}
    end
  end

  defp insert_or_update_user(changeset) do
    case NotificationBot.Repo.get_by(User, telegram_id: changeset.changes.telegram_id) do
      nil ->
        NotificationBot.Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
