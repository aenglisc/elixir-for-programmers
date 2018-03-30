defmodule Dictionary.WordList do
  @me __MODULE__
  @words "../../assets/words.txt"

  def start_link,  do: Agent.start_link(&word_list/0, name: @me)
  def random_word, do: Agent.get(@me, &Enum.random(&1))

  defp word_list do
    @words
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.split(~r/\n/)
  end
end
