defmodule GameTest do
  use ExUnit.Case
  alias Hangman.Game

  test "new_game" do
    game = Game.new_game
    assert game.game_state == :init
    assert game.turns_left == 7
    assert length(game.letters) > 0
    Enum.each(game.letters, &assert(&1 =~ ~r/[a-z]/))
  end

  test "state :won/:lost" do
    for state <- [:won, :lost] do
      game = Game.new_game |> Map.put(:game_state, state)
      assert {^game, _tally} = Game.make_move(game, "x")
    end
  end

  test "first occurence" do
    {game, _tally} = Game.new_game
    |> Game.make_move("x")
    assert game.game_state != :already_used
  end

  test "second occurence" do
    {game, _tally} = Game.new_game
    |> Game.make_move("x")
    |> elem(0)
    |> Game.make_move("x")
    assert game.game_state == :already_used
  end

  test "win condition" do
    moves = [
      {"w", :good_guess, 7}, 
      {"i", :good_guess, 7}, 
      {"b", :good_guess, 7}, 
      {"l", :good_guess, 7}, 
      {"e", :won, 7}
    ]

    game = Game.new_game("wibble")
    Enum.reduce(moves, game, &reducer(&1, &2))
  end

  test "lose condition" do
    moves = [
      {"x", :bad_guess, 6},
      {"y", :bad_guess, 5},
      {"z", :bad_guess, 4},
      {"f", :bad_guess, 3},
      {"g", :bad_guess, 2},
      {"h", :bad_guess, 1},
      {"a", :lost, 0}
    ]

    game = Game.new_game("wibble")
    Enum.reduce(moves, game, &reducer(&1, &2))
  end

  test "errors" do
    moves = [
      {"aa", :invalid, 7},
      {"A", :invalid, 7},
      {"1", :invalid, 7},
      {"ł", :invalid, 7},
      {'a', :invalid, 7},
      {:no, :invalid, 7},
      {{1}, :invalid, 7},
      {1, :invalid, 7},
    ]

    game = Game.new_game("wibble")
    Enum.reduce(moves, game, &reducer(&1, &2))
  end

  defp reducer({guess, expected_state, expected_turns_left}, game) do
    {game, _tally} = Game.make_move(game, guess)
    assert game.game_state == expected_state
    assert game.turns_left == expected_turns_left
    game
  end
end
