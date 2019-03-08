defmodule NotificationBot.Scraper do
  def get_cars() do
    case HTTPoison.get("https://www.otomoto.pl/osobowe/renault/megane/od-2014/?search%5Bfilter_float_price%3Afrom%5D=20000&search%5Bfilter_float_price%3Ato%5D=30000&search%5Bfilter_enum_fuel_type%5D%5B0%5D=diesel&search%5Bfilter_enum_damaged%5D=0&search%5Bfilter_enum_features%5D%5B0%5D=rear-parking-sensors&search%5Bfilter_enum_no_accident%5D=1&search%5Border%5D=created_at_first%3Adesc&search%5Bbrand_program_id%5D%5B0%5D=&search%5Bcountry%5D=") do
      {:ok, response} ->
        case response.status_code do
          200 ->
            cars =
              response.body
              |> Floki.find(".offer-item")
              |> Enum.map(&extract_item_information/1)

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

    IO.inspect(car)
    car
  end

  defp extract_from_attribute(car, [{_, id}, _, _, {_, link}]) do
    %NotificationBot.Car{ car | id: id, link: link }
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
      price*1.23
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
end