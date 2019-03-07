defmodule NotificationBotTest do
  use ExUnit.Case
  doctest NotificationBot

  test "greets the world" do
    assert NotificationBot.hello() == :world
  end
end
