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

  defp generate_letter(tally) do
    cond do
      # Not being too serious of course...
      List.first(tally.letters) == "e" && Enum.member?(@consonants -- Enum.into(tally.used, []), "n") ->
        "n"
      List.first(tally.letters) == "w" && Enum.member?(@consonants -- Enum.into(tally.used, []), "h") ->
        "h"
      List.first(tally.letters) == "e" && Enum.member?(@consonants -- Enum.into(tally.used, []), "s") ->
        "s"
      List.last(tally.letters) == "e" && Enum.member?(@consonants -- Enum.into(tally.used, []), "s") ->
        "s"
      List.last(tally.letters) == "e" && Enum.member?(@consonants -- Enum.into(tally.used, []), "z") ->
        "z"
      List.last(tally.letters) == "e" && Enum.member?(@consonants -- Enum.into(tally.used, []), "c") ->
        "c"
      List.last(tally.letters) == "n" && Enum.member?(@vowels -- Enum.into(tally.used, []), "o") ->
        "o"
      List.last(tally.letters) == "n" && Enum.member?(@vowels -- Enum.into(tally.used, []), "i") ->
        "i"
      (Enum.member?(tally.letters, "c") || Enum.member?(tally.letters, "s")) && Enum.member?(@consonants -- Enum.into(tally.used, []), "h") ->
        "h"
      Enum.member?(tally.letters, "c") && Enum.member?(@consonants -- Enum.into(tally.used, []), "k") ->
        "k"
      Enum.member?(tally.letters, "t") && Enum.member?(@consonants -- Enum.into(tally.used, []), "h") ->
        "h"
      Enum.member?(tally.letters, "n") && List.last(tally.letters) != "n" && Enum.member?(@consonants -- Enum.into(tally.used, []), "g") ->
        "g"
      (Enum.member?(tally.letters, "o") || Enum.member?(tally.letters, "a")) && Enum.member?(@vowels -- Enum.into(tally.used, []), "u") ->
        "u"
      List.last(tally.letters) == "t" && length(tally.letters) >= 5 && Enum.member?(@consonants -- Enum.into(tally.used, []), "g") ->
        "g"
      List.last(tally.letters) == "t" && length(tally.letters) >= 5 && Enum.member?(tally.letters, "g") && Enum.member?(@consonants -- Enum.into(tally.used, []), "h") ->
        "h"
      Enum.member?(tally.letters, "y") && Enum.member?(@consonants -- Enum.into(tally.used, []), "x") ->
        "x"
      Enum.member?(tally.letters, "p") && Enum.member?(@consonants -- Enum.into(tally.used, []), "h") ->
        "h"
      tally.turns_left < 3 && List.last(tally.letters) == "_" && Enum.member?(@vowels -- Enum.into(tally.used, []), "y") ->
        "y"
      tally.turns_left < 3 && List.last(tally.letters) == "_" && Enum.member?(@consonants -- Enum.into(tally.used, []), "d") ->
        "d"
      true ->
        Enum.random(List.wrap(List.first(@vowels -- Enum.into(tally.used, []))) ++ List.wrap(List.first(@consonants -- Enum.into(tally.used, []))))
    end
  end
end
