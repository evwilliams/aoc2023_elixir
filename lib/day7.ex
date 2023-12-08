defmodule Day7 do
  @hand_ranks [
    [1, 1, 1, 1, 1],
    [1, 1, 1, 2],
    [1, 2, 2],
    [1, 2, 2],
    [1, 1, 3],
    [2, 3],
    [1, 4],
    [5]
  ]

  def index_in(enumerable, item), do: Enum.find_index(enumerable, &(&1 == item))

  def compare_cards([], [], _), do: true

  def compare_cards([c1 | hand1], [c2 | hand2], card_ranks) do
    if c1 == c2 do
      compare_cards(hand1, hand2, card_ranks)
    else
      index_in(card_ranks, c1) <= index_in(card_ranks, c2)
    end
  end

  def compare_hands({hand1, _, type1}, {hand2, _, type2}, card_comparer) do
    cond do
      type1 < type2 -> true
      type2 < type1 -> false
      true -> card_comparer.(String.graphemes(hand1), String.graphemes(hand2))
    end
  end

  def hand_type(hand, hand_ranks) do
    hand =
      hand
      |> String.graphemes()
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.sort()

    index_in(hand_ranks, hand)
  end

  def hand_type(hand, hand_ranks, wild_card) do
    counts =
      hand
      |> String.graphemes()
      |> Enum.frequencies()

    hand =
      if Enum.count(counts) == 1 do
        [5]
      else
        wildcard_count = Map.get(counts, wild_card, 0)

        counts =
          Map.delete(counts, wild_card)
          |> Map.values()
          |> Enum.sort()
          |> Enum.reverse()

        [most | rest] = counts
        Enum.reverse([most + wildcard_count | rest])
      end

    index_in(hand_ranks, hand)
  end

  def calculate_winnings(filename, card_comparer, hand_typer) do
    Helpers.stream_lines(filename)
    |> Enum.map(&Helpers.whitespace_split/1)
    |> Enum.map(fn [hand, bid_str] ->
      {hand, String.to_integer(bid_str), hand_typer.(hand)}
    end)
    |> Enum.sort(fn h1, h2 -> compare_hands(h1, h2, card_comparer) end)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, bid, _}, rank} -> bid * rank end)
    |> Enum.sum()
  end

  def part1(filename) do
    card_ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
    card_comparer = &compare_cards(&1, &2, card_ranks)
    hand_typer = fn hand -> hand_type(hand, @hand_ranks) end
    calculate_winnings(filename, card_comparer, hand_typer)
  end

  def part2(filename) do
    card_ranks = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]
    card_comparer = &compare_cards(&1, &2, card_ranks)
    hand_typer = fn hand -> hand_type(hand, @hand_ranks, "J") end
    calculate_winnings(filename, card_comparer, hand_typer)
  end
end
