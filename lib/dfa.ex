defmodule Dfa do
  alias Dfa.Automaton
  @moduledoc """
  Module representating a Deterministic Finite-state Automaton (DFA)
  """

  def main(file_name) do
    words = get_words file_name

    IO.read(:stdio, :all)
    |> String.split("\n")
    |> delete_comments
    |> split_input
    |> split_transitions
    |> compare_words(words)
  end

  def compare_words(automaton, words) do
    Enum.each words, fn(word) ->
      word = String.graphemes(word)
      IO.puts "#{compare_word "0", automaton, word} #{word}"
    end
  end

  def compare_word(nil, _, _) do
    "NIE"
  end
  def compare_word(state, %Automaton{transitions: transitions} = automaton, [head | tail]) do
    compare_word(transitions[{state, head}], automaton, tail)
  end
  def compare_word(state, %Automaton{accepted: accepted}, []) do
    if Enum.member?(accepted, state) do
      "TAK "
    else
      "NIE "
    end
  end

  @doc """
    Gets all words from given file
  """
  def get_words(file_name) do
    {:ok, lines} = File.read file_name
    lines
    |> String.split("\n")
  end

  @doc """
    Splits each transition into map

  ## Example

      iex> att = %Dfa.Automaton{accepted: ["3"], transitions: ["0 1 a", "1 2 b", "2 3 c"]}
      iex> Dfa.split_transitions att
      %Dfa.Automaton{accepted: ["3"], transitions: %{{"0", "a"} => "1", {"1", "b"} => "2", {"2", "c"} => "3"}}
  """
  def split_transitions(%Automaton{transitions: transitions} = automaton) do
    new_transitions =
      transitions
      |> Enum.map(&map_transition/1)
      |> Enum.into(%{}, fn [a, b, c] -> {{a,c}, b} end)

    %Automaton{automaton | transitions: new_transitions}
  end

  def map_transition(transition) do
    String.split transition, " "
  end

  @doc """
    Deletes comments from input

  ## Examples

      iex> att = ["#comment", "0 1 a", "1 2 b", "2 3 c", "3"]
      iex> Dfa.delete_comments att
      ["0 1 a", "1 2 b", "2 3 c", "3"]
  """
  def delete_comments(transition) do
    Enum.filter transition, fn(row) ->
      row =~ ~r/[0-9]* [0-9]* [a-z]$/ || row =~ ~r/[0-9]/
    end
  end

  @doc """
    Splits array of input into %Dfa.Automaton

  ## Examples

      iex> att = ["0 1 a", "1 2 b", "2 3 c", "3"]
      iex> Dfa.split_input att
      %Dfa.Automaton{accepted: ["3"], transitions: ["0 1 a", "1 2 b", "2 3 c"]}
  """
  def split_input(transition) do
    {accepted, transitions} = Enum.split_with transition, fn(row) ->
      row =~ ~r/^[0-9]$/
    end
    %Automaton{transitions: transitions, accepted: accepted}
  end

end
