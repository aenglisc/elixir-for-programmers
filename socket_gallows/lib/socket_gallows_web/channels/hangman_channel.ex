defmodule SocketGallowsWeb.HangmanChannel do
  use Phoenix.Channel
  require Logger

  def join("hangman:game", _, socket) do
    {:ok, assign(socket, :game, Hangman.new_game)}
  end

  def handle_in("tally", _, socket) do
    tally = Hangman.tally(socket.assigns.game)
    push(socket, "tally", tally)
    {:noreply, socket}
  end

  def handle_in("word", _, socket) do
    word = Hangman.get_word(socket.assigns.game)
    push(socket, "word", %{word: word})
    {:noreply, socket}
  end

  def handle_in("make_move", guess, socket) do
    talle = Hangman.make_move(socket.assigns.game, guess)
    push(socket, "tally", tally)
    {:noreply, socket}
  end

  def handle_in("new_game", _, socket) do
    handle_in("tally", nil, assign(socket, :game, Hangman.new_game))
  end

  def handle_in(message, _, socket) do
    Logger.error("Unknown message: #{message}")
    {:noreply, socket}
  end
end