defmodule Demo do
  def reverse do
    receive do
      {from_pid, msg} ->
        IO.inspect from_pid
        result = String.reverse(msg)
        send(from_pid, result)
        reverse()
    end
  end
end