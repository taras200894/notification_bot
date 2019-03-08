defmodule NotificationBot.Bot do
  @bot_name :notification_bot
  def bot(), do: @bot_name

  use Telex.Bot, name: @bot_name
  use Telex.Dsl

  def handle({:command, "start", msg}, _name, _extra) do
    IO.inspect(msg)
    {_, [first_car | _tail]} = NotificationBot.Scraper.get_cars
    first_car = Map.from_struct(first_car)

    answer(generate_string_response(first_car))
  end

  defp generate_string_response(car) do
    response = Enum.map(car, fn {a, i} -> "#{Atom.to_string(a)}: #{i}" end)

    Enum.join(response, ", ")
  end
end
