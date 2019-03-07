defmodule NotificationBot.Bot do
  @bot_name :notification_bot
  def bot(), do: @bot_name

  use Telex.Bot, name: @bot_name
  use Telex.Dsl

  def handle({:command, "start", msg}, _name, _extra) do
    IO.inspect(msg)
    answer("Hi! I'm a nice bot :D")
  end
end
