defmodule Hangman.Game do
  defstruct(
    turns_left: 7,
    game_state: :init,
    letters:    [],
    used:       MapSet.new
  )
  @lowercase_letters for x <- 97..122, do: <<x>>

  def new_game,       do: new_game(Dictionary.random_word)
  def new_game(word), do: %Hangman.Game{letters: String.codepoints(word)}

  def get_word(game), do: Enum.join(game.letters, "")
  
  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally
  end

  def make_move(game, guess) when guess in @lowercase_letters do
    accept_move(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally
  end

  def make_move(game, _guess) do
    %{game | game_state: :invalid}
    |> return_with_tally
  end


  def tally(game) do
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

  defp return_with_tally(game), do: {game, tally(game)}
end