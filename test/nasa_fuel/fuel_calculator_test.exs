defmodule NasaFuel.FuelCalculatorTest do
  use ExUnit.Case
  alias NasaFuel.FuelCalculator

  test "Apollo 11 mission" do
    mass = 28801
    steps = [
      {"launch", "Earth"},
      {"land", "Moon"},
      {"launch", "Moon"},
      {"land", "Earth"}
    ]

    assert FuelCalculator.total_fuel(mass, steps) == 51898
  end

  test "Mars mission" do
    mass = 14606
    steps = [
      {"launch", "Earth"},
      {"land", "Mars"},
      {"launch", "Mars"},
      {"land", "Earth"}
    ]

    assert FuelCalculator.total_fuel(mass, steps) == 33388
  end

  test "Passenger ship mission" do
    mass = 75432
    steps = [
      {"launch", "Earth"},
      {"land", "Moon"},
      {"launch", "Moon"},
      {"land", "Mars"},
      {"launch", "Mars"},
      {"land", "Earth"}
    ]

    assert FuelCalculator.total_fuel(mass, steps) == 212161
  end
end
