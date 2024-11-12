defmodule Interpolator do
  @moduledoc """
  Модуль, получающий известную последовательность точек, от процесса Reader'a и
  составляющий значения x, по которым надо определить y и выполняющий для этого интерполяцию
  """
  def start(printer_pid, arguments) do
    spawn(fn -> loop(printer_pid, [], arguments) end)
  end

  defp loop(printer_pid, known_x_y, arguments) do
    known_x_y =
      receive do
        {:point, x_y} -> Enum.reverse([x_y | Enum.reverse(known_x_y)])
      end

    check_added_x_y(printer_pid, known_x_y, arguments)

    loop(printer_pid, known_x_y, arguments)
  end

  defp check_added_x_y(printer_pid, known_x_y, arguments) do
    method1 = arguments.method1

    if method1.points_enough?(known_x_y) do
      enough_points1 =
        Enum.slice(
          known_x_y,
          (length(known_x_y) - method1.get_enough_points_count())..(length(known_x_y) - 1)
        )

      generated_xs1 = XsGenerator.generate(enough_points1, arguments.step)
      send(printer_pid, {method1, method1.interpolate(enough_points1, generated_xs1)})
    end

    method2 = arguments.method2

    if method2.points_enough?(known_x_y) do
      enough_points2 =
        Enum.slice(
          known_x_y,
          (length(known_x_y) - method2.get_enough_points_count())..(length(known_x_y) - 1)
        )

      generated_xs2 = XsGenerator.generate(enough_points2, arguments.step)
      send(printer_pid, {method2, method2.interpolate(enough_points2, generated_xs2)})
    end
  end
end

defmodule XsGenerator do
  @moduledoc """
  Модуль, напрямую отвечающий за генерацию последовательности
  значений x с определённым шагом, для которых будет проводиться интерполяция
  """
  def generate(known_x_y, step) do
    {x_start, _} = List.first(known_x_y)
    {x_finish, _} = List.last(known_x_y)

    do_generate(x_start, x_finish, step, [])
  end

  defp do_generate(current_x, finish_x, step, result) do
    result = [current_x | result]

    if current_x > finish_x do
      Enum.reverse(result)
    else
      do_generate(current_x + step, finish_x, step, result)
    end
  end
end
