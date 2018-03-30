defmodule GameTest do
  use ExUnit.Case

  test "new_game" do
    pid = Hangman.new_game("hello")
    tally = Hangman.tally(pid)
    assert tally.game_state == :init
    assert tally.turns_left == 7
    assert length(tally.letters) == 5
  end

  test "repeated" do
    pid = Hangman.new_game("wibble")
    moves = [
      {"w", :good_guess, 7},
      {"w", :already_used, 7},
      {"n", :bad_guess, 6},
      {"n", :already_used, 6},
    ]

    for {guess, state, turns} <- moves do
      tally = Hangman.make_move(pid, guess)
      assert tally.game_state == state
      assert tally.turns_left == turns
    end
  end

  test "win condition" do
    pid = Hangman.new_game("wibble")
    moves = [
      {"w", :good_guess, 7}, 
      {"i", :good_guess, 7}, 
      {"b", :good_guess, 7}, 
      {"l", :good_guess, 7}, 
      {"e", :won, 7}
    ]

    for {guess, state, turns} <- moves do
      tally = Hangman.make_move(pid, guess)
      assert tally.game_state == state
      assert tally.turns_left == turns
      assert Enum.member? tally.used, guess
    end
  end

  test "lose condition" do
    pid = Hangman.new_game("wibble")
    moves = [
      {"x", :bad_guess, 6},
      {"y", :bad_guess, 5},
      {"z", :bad_guess, 4},
      {"f", :bad_guess, 3},
      {"g", :bad_guess, 2},
      {"h", :bad_guess, 1},
      {"a", :lost, 0}
    ]

    for {guess, state, turns} <- moves do
      tally = Hangman.make_move(pid, guess)
      assert tally.game_state == state
      assert tally.turns_left == turns
      assert Enum.member? tally.used, guess
    end
  end

  test "errors" do
    pid = Hangman.new_game("wibble")
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

    for {guess, state, turns} <- moves do
      tally = Hangman.make_move(pid, guess)
      assert tally.game_state == state
      assert tally.turns_left == turns
      assert tally.used == []
    end
  end
end
