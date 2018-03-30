defmodule GallowsWeb.Views.Helpers.GameStateHelper do
  import Phoenix.HTML, only: [raw: 1]
  @responses %{
    init: {:success, "Good luck!"},
    won: {:success, "You won!"},
    lost: {:danger, "You lost! The word was "},
    invalid: {:warning, "Please input a single lowercase letter"},
    good_guess: {:success, "Good guess!"},
    bad_guess: {:warning, "Bad guess!"},
    already_used: {:info, "You have already used that letter"}
  }
  def game_state(state, word) do
    @responses[state]
    |> alert(word)
  end

  defp alert(nil, _word), do: ""
  defp alert({class = :danger, msg}, word) do
    raw("""
    <div class="alert alert-#{class}">
      #{msg} <b>#{word}</b>
    </div>
    """)
  end
  defp alert({class, msg}, _word) do
    raw("""
    <div class="alert alert-#{class}">
      #{msg}
    </div>
    """)
  end
end