defmodule Day9 do
  def parse(filename) do
    Helpers.stream_lines(filename)
    |> Enum.map(&Helpers.ints/1)
  end

  def process_forwards(ints, acc) do
    if Enum.count(MapSet.new(ints)) == 1 and Enum.at(ints, 0) == 0 do
      acc
    else
      diffs =
        Enum.chunk_every(ints, 2, 1, :discard)
        |> Enum.map(fn [a, b] -> b - a end)

      [last | _] = Enum.reverse(ints)
      process_forwards(diffs, [last | acc])
    end
  end

  def process_backwards(ints, acc) do
    if Enum.count(MapSet.new(ints)) == 1 and Enum.at(ints, 0) == 0 do
      acc
    else
      diffs =
        Enum.chunk_every(ints, 2, 1, :discard)
        |> Enum.map(fn [a, b] -> b - a end)

      [first | _] = ints
      process_backwards(diffs, [first | acc])
    end
  end

  def part1(filename) do
    parse(filename)
    |> Enum.map(&process_forwards(&1, []))
    |> Enum.map(&Enum.sum/1)
    |> Enum.sum()
  end

  def part2(filename) do
    parse(filename)
    |> Enum.map(&process_backwards(&1, []))
    |> Enum.map(&Enum.reduce(&1, 0, fn a, acc -> a - acc end))
    |> Enum.sum()
  end
end
