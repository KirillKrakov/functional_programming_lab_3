defmodule Reader do
  @moduledoc """
  Модуль, отвечающий за чтение координат (x и y) от пользователя,
  их валидацию и отправку этих данных в процесс Interpolator'a
  """
  def start(interpolator_pid) do
    loop(interpolator_pid, nil)
  end

  defp loop(interpolator_pid, prev_x) do
    input = String.trim(IO.gets(""))

    if input == "exit" do
      IO.puts("Окончание работы программы")
      System.halt()
    end

    {validation_status, validation_result} = validate_input(input)

    if validation_status == :error do
      IO.puts(validation_result)
      loop(interpolator_pid, prev_x)
    else
      {x, y} = validation_result

      if not is_nil(prev_x) and prev_x >= x do
        IO.puts("Значение координаты x должно быть больше предыдущего")
        loop(interpolator_pid, prev_x)
      else
        send(interpolator_pid, {:point, {x, y}})
        loop(interpolator_pid, x)
      end
    end
  end

  defp validate_input(input) do
    input = String.split(String.replace(input, ~r"\s{2,}", " "), " ")

    if length(input) != 2 do
      {:error, "В строке должно быть 2 координаты - x и y"}
    else
      x_result = Float.parse(Enum.at(input, 0))
      y_result = Float.parse(Enum.at(input, 1))

      if x_result == :error or y_result == :error do
        {:error, "Нужно ввести числовые значения"}
      else
        {x_value, _} = x_result
        {y_value, _} = y_result
        {:ok, {x_value, y_value}}
      end
    end
  end
end
