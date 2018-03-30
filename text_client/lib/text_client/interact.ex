defmodule TextClient.Interact do
  @hangman_server :"hangman@Romans-MacBook-Pro"
  alias TextClient.{Player, State}
  
  def start do
    new_game()
    |> setup_game
    |> Player.play
  end

  defp setup_game(game) do
    %State{game_service: game, tally: Hangman.tally(game)}
  end

  defp new_game do
    Node.connect(@hangman_server)
    :rpc.call(@hangman_server, Hangman, :new_game, [])
  end
end