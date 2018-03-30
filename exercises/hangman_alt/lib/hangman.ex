defmodule Hangman do
  use GenServer
  defstruct(
    turns_left: 7,
    game_state: :init,
    letters:    [],
    used:       MapSet.new
  )
  @lowercase_letters for x <- 97..122, do: <<x>>

  def new_game do
    {:ok, pid} = Supervisor.start_child(Hangman.Supervisor, []) 
    pid
  end

  def new_game(x) do
    {:ok, pid} = Supervisor.start_child(Hangman.Supervisor, [x]) 
    pid
  end
  
  def tally(game_pid) do
    GenServer.call(game_pid, {:tally})
  end

  def make_move(game_pid, guess) do
    GenServer.call(game_pid, {:make_move, guess})
  end

  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  def start_link(x) do
    GenServer.start_link(__MODULE__, x)
  end

  def init(x) do
    {:ok, do_new_game(x)}
  end

  def handle_call({:tally}, _from, game) do
    {:reply, do_tally(game), game}
  end

  def handle_call({:make_move, guess}, _from, game) do
    {game, tally} = do_make_move(game, guess)
    {:reply, tally, game}
  end

  defp do_new_game(nil),       do: do_new_game(Dictionary.random_word)
  defp do_new_game(word), do: %Hangman{letters: String.codepoints(word)}

  defp do_make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally
  end

  defp do_make_move(game, guess) when guess in @lowercase_letters do
    accept_move(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally
  end

  defp do_make_move(game, _guess) do
    %{game | game_state: :invalid}
    |> return_with_tally
  end

  defp do_tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters:    reveal_guessed(game.letters, game.used),
      used:       Enum.into(game.used, [])
    }
  end

  defp accept_move(game, _guess, _already_used = true) do
    Map.put(game, :game_state, :already_used)
  end

  defp accept_move(game, guess, _already_used) do
    game
    |> Map.put(:used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state = game.letters
    |> MapSet.new
    |> MapSet.subset?(game.used)
    |> maybe_won

    %{game | game_state: new_state}
  end

  defp score_guess(game = %{turns_left: 1}, _bad_guess) do
    %{game | turns_left: 0, game_state: :lost}
  end

  defp score_guess(game = %{turns_left: turns_left}, _bad_guess) do
    %{game | turns_left: turns_left - 1, game_state: :bad_guess}
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_),    do: :good_guess

  defp reveal_guessed(letters, used) do
    Enum.map(letters, &reveal_letter(&1, MapSet.member?(used, &1)))
  end

  defp reveal_letter(letter, _in_word = true), do: letter
  defp reveal_letter(_letter, _in_word),       do: "_"

  defp return_with_tally(game), do: {game, do_tally(game)}
end