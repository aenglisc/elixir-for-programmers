defmodule TextClient.Prompter do
  alias TextClient.State
  def accept_move(game = %State{}) do
    IO.gets("Your guess: ")
    |> check_input(game)
  end

  def check_input({:error, reason}, _game) do
    IO.puts("Game ended: #{reason}")
    exit(:normal)
  end

  def check_input(:eof, _game) do
    IO.puts("Looks like you gave up")
    exit(:normal)
  end

  def check_input(input, game = %State{}) do
    input = String.trim(input)
    cond do
      input =~ ~r/\A[a-z]\z/ ->
        Map.put(game, :guess, input)
      true ->
        IO.puts("Please input a single lowercase letter\n")
        accept_move(game)
    end
  end
end