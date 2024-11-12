defmodule Algorithms.Lagrange4 do
  @moduledoc """
  Модуль, реализующий интерполяцию методом Лагранжа на основе 4 известных точек
  """
  def interpolate(known_x_y, x_to_interpolate_y) do
    do_interpolate(known_x_y, x_to_interpolate_y, [])
  end

  def get_enough_points_count, do: 4

  def points_enough?(all_known_x_y), do: length(all_known_x_y) >= get_enough_points_count()

  def get_name, do: "Интерполяция методом Лагранжа для 4 известных точек"

  defp do_interpolate(_, [], interpolated_y), do: Enum.reverse(interpolated_y)

  defp do_interpolate(known_x_y, [x | tail], interpolated_y) do
    [{x0, y0}, {x1, y1}, {x2, y2}, {x3, y3}] = known_x_y

    y =
      y0 * ((x - x1) * (x - x2) * (x - x3)) / ((x0 - x1) * (x0 - x2) * (x0 - x3)) +
        y1 * ((x - x0) * (x - x2) * (x - x3)) / ((x1 - x0) * (x1 - x2) * (x1 - x3)) +
        y2 * ((x - x0) * (x - x1) * (x - x3)) / ((x2 - x0) * (x2 - x1) * (x2 - x3)) +
        y3 * ((x - x0) * (x - x1) * (x - x2)) / ((x3 - x0) * (x3 - x1) * (x3 - x2))

    do_interpolate(known_x_y, tail, [{x, y} | interpolated_y])
  end
end
