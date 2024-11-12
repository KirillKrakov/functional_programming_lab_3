defmodule Algorithms.Newton do
  @moduledoc """
  Модуль, реализующий интерполяцию методом Ньютона на основе 4 известных точек
  """
  def interpolate(known_x_y, x_to_interpolate_y) do
    do_interpolate(known_x_y, x_to_interpolate_y, [])
  end

  def get_enough_points_count, do: 4

  def points_enough?(all_known_x_y), do: length(all_known_x_y) >= get_enough_points_count()

  def get_name, do: "Интерполяция методом Ньютона для 4 известных точек"

  defp do_interpolate(_, [], interpolated_x_y), do: Enum.reverse(interpolated_x_y)

  defp do_interpolate(known_x_y, [x | tail], interpolated_x_y) do
    y = interpolate_by_newton(x, known_x_y)
    do_interpolate(known_x_y, tail, [{x, y} | interpolated_x_y])
  end

  defp interpolate_by_newton(x, known_x_y) do
    {xs, ys} = Enum.unzip(known_x_y)

    sum = Enum.at(ys, 0)

    Enum.reduce(1..3, sum, fn i, acc ->
      t =
        Enum.reduce(0..(i - 1), 1.0, fn j, t_acc ->
          t_acc * (x - Enum.at(xs, j))
        end)

      acc + calculate_y_difference(i, 0, xs, ys) * t
    end)
  end

  defp calculate_y_difference(k, i, xs, ys) do
    if k == 0 do
      Enum.at(ys, i)
    else
      (calculate_y_difference(k - 1, i + 1, xs, ys) -
         calculate_y_difference(k - 1, i, xs, ys)) /
        (Enum.at(xs, i + k) - Enum.at(xs, i))
    end
  end
end
