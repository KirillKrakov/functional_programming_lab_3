defmodule Printer do
  @moduledoc """
  Модуль, отвечающий за вывод результатов интерполяции, получаемых от процесса Interpolator'a
  """
  def start(arguments) do
    spawn(fn -> loop(arguments) end)
  end

  defp loop(arguments) do
    receive do
      {method, result} -> print(method, result, arguments.step)
    end

    loop(arguments)
  end

  defp print(method, result, step) do
    IO.puts("\nРезультат:")

    {start_x, _} = List.first(result)

    IO.puts("#{method.get_name()} (идём от точки (#{start_x}) с шагом #{step})")
    Enum.each(result, fn {x, _} -> IO.write("#{Float.round(x, 2)}  ") end)
    IO.write("\n")
    Enum.each(result, fn {_, y} -> IO.write("#{Float.round(y, 2)}  ") end)
    IO.write("\n\n")
  end
end
