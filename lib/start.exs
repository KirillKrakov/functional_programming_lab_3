Code.require_file("lib/arguments_parser.ex")
Code.require_file("lib/reader.ex")
Code.require_file("lib/interpolator.ex")
Code.require_file("lib/algorithms/linear.ex")
Code.require_file("lib/algorithms/lagrange3.ex")
Code.require_file("lib/algorithms/lagrange4.ex")
Code.require_file("lib/algorithms/newton.ex")
Code.require_file("lib/printer.ex")

{arguments_status, arguments_result} = ArgumentsParser.parse(System.argv())

if arguments_status == :error do
  IO.puts(arguments_result)
  System.halt()
end

printer_pid = Printer.start(arguments_result)
interpolator_pid = Interpolator.start(printer_pid, arguments_result)
Reader.start(interpolator_pid)
