defmodule Algorithms.Linear do
  @moduledoc """
  Модуль, реализующий метод линейной интерполяции
  """
  def interpolate(known_x_y, x_to_interpolate_y) do
    do_interpolate(known_x_y, x_to_interpolate_y, [])
  end

  def get_enough_points_count, do: 2

  def points_enough?(all_known_x_y), do: length(all_known_x_y) >= get_enough_points_count()

  def get_name, do: "Линейная интерполяция"

  defp do_interpolate(_, [], interpolated_x_y), do: Enum.reverse(interpolated_x_y)

  defp do_interpolate(known_x_y, [x | tail], interpolated_x_y) do
    [{x0, y0}, {x1, y1}] = known_x_y

    a = (y1 - y0) / (x1 - x0)
    b = y0 - a * x0

    do_interpolate(known_x_y, tail, [{x, a * x + b} | interpolated_x_y])
  end
end
