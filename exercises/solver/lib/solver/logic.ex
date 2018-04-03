defmodule Solver.Logic do
  @vowels     String.codepoints("eaoiuy")
  @consonants String.codepoints("tnshrdlcmwfgpbvkjxqz")

  @start ["Let's go!", "Bring it on!", "Let's roll!"]
  @happy ["Aha!", "Ha!", "Toasty!", "Woo!", "Yay!", "Yes!"]
  @sad   ["Argh!", "Oh well.", "Hmmm...", "Bah!", "Fiddlesticks!", "Pff..."]
  @phrases %{
    init:       @start,
    won:        @happy,
    lost:       @sad,
    good_guess: @happy,
    bad_guess:  @sad
  }

  def start do
    game = Hangman.new_game
    tally = Hangman.tally(game)
    IO.puts "Now guessing \"#{Hangman.get_word(game)}\"\n"
    :timer.sleep 1000
    play_turn(tally, game)
  end

  defp play_turn(tally = %{game_state: state}, _game) when state in [:won, :lost] do
    announce_tally(tally)
    :timer.sleep 1000
    exit(:normal)
  end

  defp play_turn(tally, game) do
    tally
    |> announce_tally
    |> make_move(game)
    |> play_turn(game)
  end

  defp announce_tally(tally) do
    IO.puts "Word so far: #{Enum.join(tally.letters, " ")}"
    IO.puts "Letters used: #{Enum.join(tally.used, " ")}"
    IO.puts "Turns left: #{tally.turns_left}"
    IO.puts Enum.random(@phrases[tally.game_state])
    tally
  end

  defp make_move(%{game_state: :init}, game) do
    :timer.sleep 1000
    IO.puts "\nLet's try e"
    :timer.sleep 1000
    Hangman.make_move(game, "e")
  end

  defp make_move(tally, game) do
    :timer.sleep 1000
    letter = generate_letter(tally)
    IO.puts "\nLet's try #{letter}..."
    :timer.sleep 1000
    Hangman.make_move(game, letter)
  end

  # should be using regexp if this were serious
  # can't pattern match end of a lsit
  # frequent endings (-ing, -ed, -ght etc.) can't be guessed properly
  # it still occasionally guesses words the way it is though!

  defp generate_letter(tally = %{letters: ["e", "_" | _], used: used}) do
    cond do
      "n" not in used -> "n"
      "s" not in used -> "s"
      "m" not in used -> "m"
      true -> generate_frequent(tally)
    end
  end

  defp generate_letter(tally = %{letters: ["c", "_" | _], used: used}) do
    cond do
      "h" not in used -> "h"
      true -> generate_frequent(tally)
    end
  end

  defp generate_letter(tally = %{letters: ["t", "_" | _], used: used}) do
    cond do
      "h" not in used -> "h"
      true -> generate_frequent(tally)
    end
  end

  defp generate_letter(tally = %{letters: ["s", "_" | _], used: used}) do
    cond do
      "h" not in used -> "h"
      true -> generate_frequent(tally)
    end
  end

  defp generate_letter(tally = %{letters: ["i", "_" | _], used: used}) do
    cond do
      "n" not in used -> "n"
      "m" not in used -> "m"
      true -> generate_frequent(tally)
    end
  end

  defp generate_letter(tally = %{letters: ["i", "n", "_" | _], used: used}) do
    cond do
      "q" not in used -> "q"
      true -> generate_frequent(tally)
    end
  end

  defp generate_letter(tally = %{letters: ["_", "e" | _], used: used}) do
    cond do
      "r" not in used -> "r"
      "d" not in used -> "d"
      true -> generate_frequent(tally)
    end
  end

  defp generate_letter(tally = %{letters: ["_", "h" | _], used: used}) do
    cond do
      "w" not in used -> "w"
      true -> generate_frequent(tally)
    end
  end

  defp generate_letter(tally = %{letters: ["w", "_" | _], used: used}) do
    cond do
      "h" not in used -> "h"
      true -> generate_frequent(tally)
    end
  end

  defp generate_letter(tally = %{letters: letters, used: used}) do
    cond do
      "g" in letters and "h" not in used -> "h"
      "h" in letters and "g" not in used -> "g"
      "n" in letters and "g" not in used -> "g"
      true -> generate_frequent(tally)
    end
  end

  defp generate_frequent(tally) do
      frequent_vowel = List.wrap(List.first(@vowels -- tally.used))
      frequent_consonant = List.wrap(List.first(@consonants -- tally.used))
      Enum.random(frequent_vowel ++ frequent_consonant)
  end
end
