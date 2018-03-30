defmodule Procs do
  def greeter(what_to_say, count \\ 0) do
    receive do
      {:boom, reason} ->
        exit(reason)
      {:reset} ->
        greeter(what_to_say, 0)
      {:add, n} ->
        greeter(what_to_say, count + n)
      msg ->
        IO.puts "#{count} - #{what_to_say}: #{msg}"
        greeter(what_to_say, count + 1)
      _ ->
        greeter(what_to_say, count)
    end
  end
end