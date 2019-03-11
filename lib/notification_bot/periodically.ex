defmodule NotificationBot.Periodically do
  use GenServer
  import Ecto.Query

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    perform_check()
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 5 * 60 * 1000) # In 5 minutes
  end

  defp perform_check do
    active_filters = NotificationBot.Filter
     |> where(is_active: true)
     |> NotificationBot.Repo.all

    for filter <- active_filters do
      NotificationBot.Scraper.get_cars(filter)
    end
  end
end
