defmodule Blinker do
  use GenServer
  alias ElixirALE.GPIO
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_opts) do
    {:ok, led} = GPIO.start_link(17, :output)
    schedule_cast()
    {:ok, %{led: led, state: true}}
  end

  def schedule_cast() do
    Process.send_after(self(), :time_elapsed, 1_000)
  end

  def handle_info(:time_elapsed, %{led: led, state: true}) do
    schedule_cast()
    GPIO.write(led, 1)
    {:noreply, %{led: led, state: false}}
  end

  def handle_info(:time_elapsed, %{led: led, state: false}) do
    schedule_cast()
    GPIO.write(led, 0)
    {:noreply, %{led: led, state: true}}
  end
end