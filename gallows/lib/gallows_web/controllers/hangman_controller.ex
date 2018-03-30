defmodule GallowsWeb.HangmanController do
  use GallowsWeb, :controller

  def new_game(conn, _params) do
    render conn, "new_game.html"
  end

  def create_game(conn, _params) do
    game = Hangman.new_game
    tally = Hangman.tally(game)
    word = Hangman.get_word(game)
    conn
    |> put_session(:game, game)
    |> render("game_field.html", tally: tally, word: word)
  end

  def make_move(conn, params) do
    guess = params["make_move"]["guess"]
    tally = conn
    |> get_session(:game)
    |> Hangman.make_move(guess)
    word = conn
    |> get_session(:game)
    |> Hangman.get_word
    put_in(conn.params["make_move"]["guess"], "")
    |> render("game_field.html", tally: tally, word: word)
  end
end
