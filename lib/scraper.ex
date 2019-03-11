defmodule NotificationBot.Scraper do
  def get_cars(filter) do
    case HTTPoison.get(filter.link) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            cars =
              response.body
              |> Floki.find(".offer-item")
              |> Enum.map(&extract_item_information/1)

            check_cars(cars, filter)
            {:ok, cars}

          _ -> :error
        end
      _ -> :error
    end
  end

  defp extract_item_information({_tag, attrs, children}) do
    car = %NotificationBot.Car{}
    |> extract_from_attribute(attrs)
    |> extract_from_children(Floki.raw_html(children))

    car
  end

  defp extract_from_attribute(car, [{_, id}, _, _, {_, link}]) do
    %NotificationBot.Car{ car | number: id, link: link }
  end

  defp extract_from_children(car, children) do
    car
    |> find_price(children)
    |> find_additional_info(children)
    |> find_subtitle(children)
    |> find_location(children)
  end

  defp find_price(car, children) do
    {_, _, [{_, _, [price, {_, _, [currency]}]}, {_, _, [price_detail]}]} =
      Floki.find(children, ".offer-price")
      |> hd()

    price = String.replace(price, ~r"[a-z /]", "")
    |> String.to_integer

    price_detail = if price_detail =~ "Brutto", do: "Brutto", else: "Netto"

    %NotificationBot.Car{ car | price: price,
      currency: currency,
      price_detail: price_detail,
      price_brutto: price_brutto(price, price_detail)
    }
  end

  defp price_brutto(price, price_detail) do
    if price_detail =~ "Brutto" do
      price
    else
      Kernel.trunc(price * 1.23)
    end
  end

  defp find_additional_info(car, children) do
    { _, _, [ {_, _, [{_,_,[year]}]}, {_, _, [{_, _, [mileage]}]}, {_, _, [{_, _, [engine_capacity]}]}, {_, _, [{_, _, [
      fuel_type]}]}]} =
      Floki.find(children, ".offer-item__params")
      |> hd()

    %NotificationBot.Car{car | year: year, mileage: mileage, engine_capacity: engine_capacity,
      fuel_type: fuel_type}
  end

  defp find_subtitle(car, children) do
    { _, _, [subtitle]} =
      Floki.find(children, ".offer-item__subtitle")
      |> hd()

    %NotificationBot.Car{car | subtitle: subtitle}
  end

  defp find_location(car, children) do
    { _, _, [ _, { _, _, [location | _]}]} =
      Floki.find(children, ".offer-item__location")
      |> hd()

    %NotificationBot.Car{car | location: String.trim(location)}
  end

  defp check_cars(cars, filter) do
    for car <- cars do
      create_and_notify(car, filter)
    end
  end

  defp create_and_notify(car, filter) do
    user = NotificationBot.Repo.get_by(NotificationBot.User, id: filter.user_id)
    IO.inspect(user)
    car = %NotificationBot.Car{car | filter_id: filter.id}
    changeset = NotificationBot.Car.changeset(%NotificationBot.Car{}, Map.from_struct(car))

#    IO.inspect(changeset.changes.number)

    case NotificationBot.Repo.get_by(NotificationBot.Car, number: car.number) do
      nil ->
        NotificationBot.Repo.insert(changeset)
        Telex.send_message(user.telegram_id, generate_string_response(changeset), bot: :notification_bot)
      car ->
        {:ok, car}
    end
  end

  defp generate_string_response(car) do
#    car = Map.from_struct(car)
    IO.inspect(car)
    response = Enum.map(car.changes, fn {a, i} -> "#{Atom.to_string(a)}: #{i}" end)

    Enum.join(response, ", ")
  end
end