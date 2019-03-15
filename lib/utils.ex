defmodule Buttons do
  require Logger

  def create_inline_button(row) do
    row
    |> Enum.map(fn ops ->
      Map.merge(%Telex.Model.InlineKeyboardButton{}, Enum.into(ops, %{})) end)
  end

  def create_inline(data \\ [[]]) do
    data =
      data
      |> Enum.map(&Buttons.create_inline_button/1)

    %Telex.Model.InlineKeyboardMarkup{inline_keyboard: data}
  end

  def donation_text() do
    "Hi! Click the button below.\nThank you for using this bot️"
  end

  def generate_donation_button() do
    Buttons.create_inline [[[text: "Donate", url: "paypal.me/Stopenchuk"]]]
  end

  def generate_hide_and_del_button() do
    Buttons.create_inline [[[text: "Hide", callback_data: "action:hide"]], [[text: "Delete elements", callback_data: "action:delete:elements"]]]
  end

  def generate_show_button() do
    Buttons.create_inline [[[text: "Show", callback_data: "action:show"]]]
  end

  def generate_start_buttons() do
    Buttons.create_inline [[[text: "Create filter", callback_data: "action:create_filter"]], [[text: "Show Filter List", callback_data: "action:show"]], [[text: "Donate", callback_data: "action:donate"]]]
  end

  def generate_create_filter_buttons() do
    Buttons.create_inline [[[text: "Create filter", callback_data: "action:create_filter"]]]
  end
end
