defmodule GallowsWeb.HangmanView do
  use GallowsWeb, :view
  import GallowsWeb.Views.Helpers.GameStateHelper

  def game_over?(%{ game_state: game_state }), do: game_state in [:won, :lost]

  def join_letters(letters), do: Enum.join letters, " "
  
  def new_game_button(conn) do
    button("New game", to: hangman_path(conn, :create_game))
  end

  def turn(left, target) when target >= left, do: "opacity: 1"
  def turn(_left, _target), do: "opacity: 0.1"
end
