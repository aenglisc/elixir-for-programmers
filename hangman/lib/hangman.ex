defmodule Hangman do
  def new_game do
    {:ok, pid} = Supervisor.start_child(Hangman.Supervisor, [])
    # IO.inspect Node.list
    pid
  end
  
  def tally(game_pid) do
    GenServer.call(game_pid, {:tally})
  end

  def make_move(game_pid, guess) do
    GenServer.call(game_pid, {:make_move, guess})
  end

  def get_word(game_pid) do
    GenServer.call(game_pid, {:get_word})
  end
end