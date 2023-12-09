defmodule Day9 do
  def process(ints, accumulator, acc) do
    if Enum.all?(ints, &(&1 == 0)) do
      acc
    else
      Enum.chunk_every(ints, 2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)
      |> process(accumulator, [accumulator.(ints) | acc])
    end
  end

  def part1(filename) do
    Helpers.stream_lines(filename, of: &Helpers.ints/1)
    |> Enum.map(fn ints -> process(ints, &List.last/1, []) end)
    |> Enum.map(&Enum.sum/1)
    |> Enum.sum()
  end

  def part2(filename) do
    Helpers.stream_lines(filename, of: &Helpers.ints/1)
    |> Enum.map(fn ints -> process(ints, &List.first/1, []) end)
    |> Enum.map(fn first_nums -> Enum.reduce(first_nums, &-/2) end)
    |> Enum.sum()
  end
end
