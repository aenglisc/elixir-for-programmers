defmodule TextClient.Player do
  alias TextClient.{Mover, Prompter, State, Summary}
  @won "You won!"
  @lost "Sorry, you lost"
  @correct "Good guess!"
  @wrong "Sorry, that isn't in the word"
  @repeat "You've already used that letter"

  def play(game = %State{tally: %{game_state: :won}}),  do: exit_game(game, @won)
  def play(game = %State{tally: %{game_state: :lost}}), do: exit_game(game, @lost)

  def play(game = %State{tally: %{game_state: :good_guess}}),   do: continue(game, @correct)
  def play(game = %State{tally: %{game_state: :bad_guess}}),    do: continue(game, @wrong)
  def play(game = %State{tally: %{game_state: :already_used}}), do: continue(game, @repeat)
  
  def play(game), do: continue(game)

  defp continue(game, message) do
    IO.puts(message)
    continue(game)
  end

  defp continue(game) do
    game
    |> Summary.display
    |> Prompter.accept_move
    |> Mover.make_move
    |> play
  end

  defp exit_game(game = %State{game_service: pid}, message) do
    Summary.display(game)
    IO.puts "The word was #{Hangman.get_word(pid)}"
    IO.puts(message)
    exit(:normal)
  end
end