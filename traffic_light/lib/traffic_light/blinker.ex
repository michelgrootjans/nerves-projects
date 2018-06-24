defmodule Blinker do
  use GenServer
  alias ElixirALE.GPIO
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_opts) do
    {:ok, red} = GPIO.start_link(17, :output)
    {:ok, yellow} = GPIO.start_link(27, :output)
    {:ok, green} = GPIO.start_link(22, :output)

    cycle = :queue.new()
    cycle = :queue.in(%{key: :green,  interval: 2_000}, cycle)
    cycle = :queue.in(%{key: :yellow, interval: 1_000}, cycle)
    cycle = :queue.in(%{key: :red,    interval: 2_000}, cycle)

    schedule_cycle(1)
    {:ok, %{red: red, yellow: yellow, green: green, cycle: cycle}}
  end

  def schedule_cycle(time) do
    Process.send_after(self(), :apply_cycle, time)
  end

  def handle_info(:apply_cycle, state) do
    {{:value, light}, other_lights} = :queue.out(state.cycle)

    color_me(light.key, state)
    schedule_cycle(light.interval)

    {:noreply, %{state | cycle: :queue.in(light, other_lights)}}
  end

  def color_me(color, state) do
    GPIO.write(state.red, color == :red)
    GPIO.write(state.yellow, color == :yellow)
    GPIO.write(state.green, color == :green)
  end

end
