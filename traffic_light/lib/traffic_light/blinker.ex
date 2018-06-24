defmodule Blinker do
  use GenServer
  alias ElixirALE.GPIO
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_opts) do
    {:ok, led} = GPIO.start_link(27, :output)
    Process.send_after(self(), :switch_on, 200)
    {:ok, %{led: led, blinking: false}}
  end

  def write(pid, true), do: GenServer.cast(pid, :start)
  def write(pid, false), do: GenServer.cast(pid, :stop)

  def handle_cast(:start, state), do: {:noreply, %{state | blinking: true } }
  def handle_cast(:stop,  state), do: {:noreply, %{state | blinking: false} }

  def handle_info(:switch_on, %{blinking: true} = state) do
    GPIO.write(state.led, 1)
    Process.send_after(self(), :switch_off, 200)
    {:noreply, state}
  end

  def handle_info(:switch_off, %{blinking: true} = state) do
    GPIO.write(state.led, 0)
    Process.send_after(self(), :switch_on, 200)
    {:noreply, state}
  end

  def handle_info(_, state) do
    GPIO.write(state.led, 0)
    Process.send_after(self(), :switch_on, 200)
    {:noreply, state}
  end
end
