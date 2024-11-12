defmodule ArgumentsParser do
  @moduledoc """
  Модуль, отвечающий за обработку аргументов, переданных в виде
  списка строк, и извлечение из них методов интерполяции и шага
  """
  def parse(arguments) do
    {method_status, method_result} = do_parse_methods(arguments, 0, nil, nil)

    if method_status == :error do
      {method_status, method_result}
    else
      {step_status, step_result} = do_parse_step(arguments, 0)

      if step_status == :error do
        {step_status, step_result}
      else
        {method1, method2} = method_result

        {:ok,
         %{
           :method1 => method1,
           :method2 => method2,
           :step => step_result
         }}
      end
    end
  end

  defp do_parse_methods(arguments, i, method1, method2) do
    if i == length(arguments) do
      {:ok, {method1, method2}}
    else
      argument = Enum.at(arguments, i)
      [key, value] = String.split(argument, "=")

      {status, result} =
        case key do
          "method1" -> do_parse_method_name(value)
          "method2" -> do_parse_method_name(value)
          _ -> {:skip, nil}
        end

      if status == :skip do
        do_parse_methods(arguments, i + 1, method1, method2)
      else
        if status == :error do
          {status, result}
        else
          case key do
            "method1" -> do_parse_methods(arguments, i + 1, result, method2)
            "method2" -> do_parse_methods(arguments, i + 1, method1, result)
          end
        end
      end
    end
  end

  defp do_parse_method_name(name) do
    case name do
      "linear" -> {:ok, Algorithms.Linear}
      "newton" -> {:ok, Algorithms.Newton}
      "lagrange3" -> {:ok, Algorithms.Lagrange3}
      "lagrange4" -> {:ok, Algorithms.Lagrange4}
      _ -> {:error, "Не получается определить название метода: '#{name}'"}
    end
  end

  defp do_parse_step(arguments, i) do
    if i == length(arguments) do
      {:error, "Аргумент \"step\" не указан"}
    else
      argument = Enum.at(arguments, i)
      [key, value] = String.split(argument, "=")

      status =
        case key do
          "step" -> :ok
          _ -> :skip
        end

      if status == :skip do
        do_parse_step(arguments, i + 1)
      else
        try do
          {:ok, String.to_float(value)}
        rescue
          ArgumentError ->
            try do
              {:ok, String.to_integer(value)}
            rescue
              ArgumentError -> {:error, "Не получается определить значение шага: '#{value}'"}
            end
        end
      end
    end
  end
end
