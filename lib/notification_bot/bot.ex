defmodule NotificationBot.Bot do
  @bot_name :notification_bot
  def bot(), do: @bot_name

  use Telex.Bot, name: @bot_name
  use Telex.Dsl

  import Ecto.Query

  alias NotificationBot.User
  alias NotificationBot.Filter

  def handle({:command, "start", msg}, _name, _extra) do
    {_, user} = User.create_user_from_telegram(msg)

    markup = Buttons.generate_start_buttons()
    message = "Hello #{user.first_name}!"

    answer(
      message,
      parse_mode: "HTML",
      disable_web_page_preview: true,
      reply_markup: markup
    )
  end

  def handle({:callback_query, %{ data: "action:donate", message: %{ chat: %{ id: telegram_id }}} = msg}, _name, _) do
    markup = Buttons.generate_donation_button()
    answer(msg, Buttons.donation_text(), parse_mode: "HTML", reply_markup: markup)
  end

  def handle({:callback_query, %{data: "action:create_filter", message: %{chat: %{id: cid}, message_id: mid} } = msg}, _name, _) do
    answer(
      msg,
      "Send me a link!",
      reply_markup: %Telex.Model.ForceReply{
        force_reply: true,
        selective: true
      },
      reply_to_message_id: mid
    )
  end

  # create_filter second step
  def handle(_, _name, %{ update: %{ message: %{ text: t, chat: %{ id: id }, reply_to_message: _} } = msg}) do
    Filter.create_filter_from_telegram(t, id)

    answer(
      msg,
      "Filter added",
      parse_mode: "HTML",
      reply_markup: %Telex.Model.ReplyKeyboardRemove{
        remove_keyboard: true
      }
    )
  end

  def handle({:callback_query,%{data: "action:show",message: %{chat: %{id: telegram_id}}} = msg}, _name, _) do
    user = NotificationBot.Repo.get_by(User, telegram_id: telegram_id)
    filters = NotificationBot.Filter
                |> where(user_id: ^user.id)
                |> NotificationBot.Repo.all

    markup = Buttons.generate_hide_and_del_button()

    edit(
      :inline,
      msg,
      "📜 Here is your filters list: 📜",
      parse_mode: "HTML",
      disable_web_page_preview: true,
      reply_markup: Filter.format_list(filters)
    )
  end

  def handle({:callback_query, %{data: "del:done"} = msg}, _name, _) do
    markup = Buttons.generate_start_buttons()
    edit(:inline, msg, "Hello again!", parse_mode: "HTML", reply_markup: markup)
  end

  def handle({:command, "create_filter", msg}, _name, _extra) do
    Filter.create_filter_from_telegram(msg.text, msg.chat.id)

    answer(
      msg,
      "Filter added",
      parse_mode: "HTML",
      reply_markup: %Telex.Model.ReplyKeyboardRemove{
        remove_keyboard: true
      }
    )
  end
end
