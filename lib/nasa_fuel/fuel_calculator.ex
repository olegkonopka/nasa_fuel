defmodule NasaFuel.FuelCalculator do
  def total_fuel(mass, steps) do
    steps = Enum.reverse(steps)
    total = do_total_fuel(mass, steps)
    total - mass
  end

  defp do_total_fuel(mass, []), do: mass

  defp do_total_fuel(mass, [{action, planet} | rest]) do
    gravity = gravity(planet)
    fuel = compute_fuel(mass, gravity, action)
    do_total_fuel(mass + fuel, rest)
  end

  defp compute_fuel(mass, gravity, "launch") do
    calculate(mass, gravity, 0.042, 33)
  end

  defp compute_fuel(mass, gravity, "land") do
    calculate(mass, gravity, 0.033, 42)
  end

  defp calculate(mass, gravity, rate, subtract) do
    fuel = trunc(mass * gravity * rate - subtract)

    if fuel > 0 do
      fuel + calculate(fuel, gravity, rate, subtract)
    else
      0
    end
  end

  defp gravity("Earth"), do: 9.807
  defp gravity("Moon"), do: 1.62
  defp gravity("Mars"), do: 3.711
end
