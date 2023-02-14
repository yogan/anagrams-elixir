defmodule Anagrammar do
  @moduledoc """

  Example code from this arcticle:
  https://samuelmullen.com/articles/elixir-processes-send-and-receive
  """

  # When missing, install with: sudo apt install wngerman wamerican
  # @dictionary_de "/usr/share/dict/ngerman"
  @dictionary_en "/usr/share/dict/american-english"

  def build_list(accumulator_pid) do
    words()
    |> Enum.each(&add_anagram(accumulator_pid, &1))
  end

  def get_list(accumulator_pid) do
    send(accumulator_pid, {self(), :list})

    receive do
      {:ok, list} ->
        list
        |> Enum.each(&IO.inspect/1)
    end
  end

  defp words do
    File.read!(@dictionary_en)
    |> String.split("\n")
  end

  defp add_anagram(accumulator_pid, word) do
    spawn(fn -> _add_anagram(accumulator_pid, word) end)
  end

  defp _add_anagram(accumulator_pid, word) do
    send(accumulator_pid, {self(), {:add, parse(word)}})

    receive do
      :ok -> :ok
    end
  end

  defp parse(word) do
    letters =
      word
      |> String.downcase()
      |> String.split("")
      |> Enum.sort(&(&1 <= &2))
      |> Enum.join()

    {letters, word}
  end
end

defmodule Accumulator do
  def loop(anagrams \\ %{}) do
    receive do
      {from, {:add, {letters, word}}} ->
        anagrams = add_word(anagrams, letters, word)
        send(from, :ok)
        # must put loop/0 inside each match
        loop(anagrams)

      {from, :list} ->
        send(from, {:ok, list_anagrams(anagrams)})
        loop(anagrams)
    end
  end

  defp add_word(anagrams, letters, word) do
    words = Map.get(anagrams, letters, [])

    anagrams
    |> Map.put(letters, [word | words])
  end

  defp list_anagrams(anagrams) do
    anagrams
    |> Enum.filter(fn {_, v} -> length(v) >= 3 end)
  end
end
