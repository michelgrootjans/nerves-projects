# TrafficLight

This is a traffic light simulation with a Raspberry Pi 3. To make it work, do the following:

- insert a memory card in your computer
- execute the following
> export MIX_TARGET=rpi3
> export NERVES_NETWORK_SSID=[YOUR NETWORK NAME]
> export NERVES_NETWORK_PSK=[YOUR NETWORK PASSWORD]
> mix do deps.get, firmware, firmware.burn

On the Raspberry Pi, create the following connections:
GPIO 17 > red    LED > 330 Ohm > GND
GPIO 27 > yellow LED > 330 Ohm > GND
GPIO 22 > green  LED > 330 Ohm > GND

Insert the memory card in the Raspberry PI, power it on, and watch the magic!

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start your Nerves app:
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: http://www.nerves-project.org/
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
