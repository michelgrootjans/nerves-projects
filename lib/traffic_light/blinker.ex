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

    lights = :queue.new()
    lights = :queue.in(%{pid: green,  key: :green,  interval: 3_000}, lights)
    lights = :queue.in(%{pid: yellow, key: :yellow, interval: 1_000}, lights)
    lights = :queue.in(%{pid: red,    key: :red,    interval: 3_000}, lights)

    schedule_cast(1)
    {:ok, %{red: red, yellow: yellow, green: green, lights: lights}}
  end

  def schedule_cast(time) do
    Process.send_after(self(), :cycle_lights, time)
  end

  def handle_info(:cycle_lights, state) do
    {{:value, light}, other_lights} = :queue.out(state.lights)

    color_me(light.key, state)
    schedule_cast(light.interval)

    {:noreply, %{state | lights: :queue.in(light, other_lights)}}
  end

  def color_me(color, state) do
    GPIO.write(state.red, color == :red)
    GPIO.write(state.yellow, color == :yellow)
    GPIO.write(state.green, color == :green)
  end

end
