defmodule TrafficLight do
  use GenServer
  alias ElixirALE.GPIO
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_opts) do
    {:ok, red} = GPIO.start_link(17, :output)
#    {:ok, yellow} = GPIO.start_link(27, :output)
    {:ok, yellow} = Blinker.start_link([])
    {:ok, green} = GPIO.start_link(22, :output)

    # starting ...
    GPIO.write(red, 1)
    GPIO.write(yellow, 1)
    GPIO.write(green, 1)


    cycle = :queue.new()
    cycle = :queue.in(%{color: :green,  interval: 500}, cycle)
    cycle = :queue.in(%{color: :yellow, interval: 500}, cycle)
    cycle = :queue.in(%{color: :red,    interval: 500}, cycle)
    cycle = :queue.in(%{color: :yellow, interval: 500}, cycle)

    schedule_cycle(1_000)
    {:ok, %{red: red, yellow: yellow, green: green, cycle: cycle}}
  end

  def schedule_cycle(time) do
    Process.send_after(self(), :apply_cycle, time)
  end

  def handle_info(:apply_cycle, state) do
    {{:value, led}, other_leds} = :queue.out(state.cycle)

    color_me(led.color, state)
    schedule_cycle(led.interval)

    {:noreply, %{state | cycle: :queue.in(led, other_leds)}}
  end

  def color_me(color, state) do
    GPIO.write(state.red, color == :red)
#    GPIO.write(state.yellow, color == :yellow)
    Blinker.write(state.yellow, color == :yellow)
    GPIO.write(state.green, color == :green)
  end

end
