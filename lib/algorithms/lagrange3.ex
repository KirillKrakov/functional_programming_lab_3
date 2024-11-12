defmodule Algorithms.Lagrange3 do
  @moduledoc """
  Модуль, реализующий интерполяцию методом Лагранжа на основе 3 известных точек
  """
  def interpolate(known_x_y, x_to_interpolate_y) do
    do_interpolate(known_x_y, x_to_interpolate_y, [])
  end

  def get_enough_points_count, do: 3

  def points_enough?(all_known_x_y), do: length(all_known_x_y) >= get_enough_points_count()

  def get_name, do: "Интерполяция методом Лагранжа для 3 известных точек"

  defp do_interpolate(_, [], interpolated_x_y), do: Enum.reverse(interpolated_x_y)

  defp do_interpolate(known_x_y, [x | tail], interpolated_x_y) do
    [{x0, y0}, {x1, y1}, {x2, y2}] = known_x_y

    y =
      y0 * ((x - x1) * (x - x2)) / ((x0 - x1) * (x0 - x2)) +
        y1 * ((x - x0) * (x - x2)) / ((x1 - x0) * (x1 - x2)) +
        y2 * ((x - x0) * (x - x1)) / ((x2 - x0) * (x2 - x1))

    do_interpolate(known_x_y, tail, [{x, y} | interpolated_x_y])
  end
end
