defmodule Day4 do
  def parse_line(line) do
    ["Card " <> card_num, numbers] = String.split(line, ":")
    card_num = String.to_integer(String.trim(card_num))

    [winners, held] =
      String.split(numbers, "|")
      |> Enum.map(&String.split/1)
      |> Enum.map(fn split -> Enum.map(split, &String.to_integer/1) end)
      |> Enum.map(&MapSet.new/1)

    win_count = Enum.count(MapSet.intersection(winners, held))

    {card_num, winners, held, win_count}
  end

  def part1(filename) do
    Helpers.stream_lines(filename)
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn {_card_num, _winners, _held, win_count} ->
      if win_count > 0, do: 2 ** (win_count - 1), else: 0
    end)
    |> Enum.sum()
  end

  def gain_cards([], total_card_count), do: total_card_count

  def gain_cards(games, total_card_count) do
    [{_card_num, _winners, _held, win_count, card_count} | rest] = games

    rest =
      Enum.with_index(rest)
      |> Enum.map(fn {{cn, w, h, wc, cc} = card_info, idx} ->
        if idx < win_count do
          {cn, w, h, wc, cc + card_count}
        else
          card_info
        end
      end)

    gain_cards(rest, total_card_count + card_count)
  end

  def part2(filename) do
    games =
      Helpers.stream_lines(filename)
      |> Enum.map(&parse_line/1)
      |> Enum.map(&Tuple.append(&1, 1))

    gain_cards(games, 0)
  end
end
