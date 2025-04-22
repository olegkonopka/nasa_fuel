defmodule NasaFuelWeb.Live.CalculatorLive do
  use NasaFuelWeb, :live_view

  alias NasaFuel.FuelCalculator

  @planets ["Earth", "Moon", "Mars"]
  @actions ["launch", "land"]

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        mass: "",
        steps: [],
        new_action: "launch",
        new_planet: "Earth",
        fuel: nil,
        error: nil,
        actions: @actions,
        planets: @planets
      )
    IO.inspect(@planets, label: "🚀 planets at mount")
    IO.inspect(socket.assigns)
    {:ok, socket}
  end

  def handle_event("update_mass", %{"mass" => mass}, socket) do
    {:noreply, assign_and_recalculate(socket, mass, socket.assigns.steps)}
  end

  def handle_event("add_step", _params, socket) do
    new_step = {socket.assigns.new_action, socket.assigns.new_planet}
    steps = socket.assigns.steps ++ [new_step]
    {:noreply, assign_and_recalculate(socket, socket.assigns.mass, steps)}
  end

  def handle_event("remove_step", %{"index" => index}, socket) do
    index = String.to_integer(index)
    steps = List.delete_at(socket.assigns.steps, index)
    {:noreply, assign_and_recalculate(socket, socket.assigns.mass, steps)}
  end

  def handle_event("change_step", %{"step" => %{"action" => action, "planet" => planet}}, socket) do
    {:noreply, assign(socket, new_action: action, new_planet: planet)}
  end

  defp assign_and_recalculate(socket, mass, steps) do
    parsed_mass =
      case Integer.parse(mass) do
        {val, _} when val > 0 -> val
        _ -> nil
      end

    cond do
      parsed_mass == nil ->
        assign(socket, mass: mass, steps: steps, fuel: nil, error: "Mass must be a positive number")

      true ->
        fuel =
          if steps != [] do
            FuelCalculator.total_fuel(parsed_mass, steps)
          else
            nil
          end

        assign(socket, mass: mass, steps: steps, fuel: fuel, error: nil)
    end
  end
end
