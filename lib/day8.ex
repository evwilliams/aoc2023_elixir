defmodule Day8 do
  def parse(filename) do
    [[moves] | mappings] =
      Helpers.stream_lines(filename)
      |> Enum.map(&Regex.replace(~r'[=\(\),]', &1, ""))
      |> Enum.map(&Regex.split(~r'\s+', &1, trim: true))

    moves =
      String.graphemes(moves)
      |> Enum.with_index(fn move, idx -> {idx, move} end)
      |> Map.new()

    mappings =
      mappings
      |> Enum.map(fn [src, left, right] -> {src, {left, right}} end)
      |> Map.new()

    {moves, mappings}
  end

  def count_hops(_, current, %{} = target, _, count) when is_map_key(target, current), do: count

  def count_hops(_, current, target, _, count) when current == target, do: count

  def count_hops(moves, current, target, mapping, count) do
    {left, right} = Map.get(mapping, current)
    move = Map.get(moves, rem(count, Enum.count(moves)))
    next = if move == "L", do: left, else: right
    count_hops(moves, next, target, mapping, count + 1)
  end

  def part1(filename) do
    {moves, mapping} = parse(filename)
    count_hops(moves, "AAA", "ZZZ", mapping, 0)
  end

  def part2(filename) do
    {moves, mapping} = parse(filename)

    %{starters: starters, targets: targets} =
      Enum.group_by(mapping, fn {src, _} ->
        case String.at(src, -1) do
          "A" -> :starters
          "Z" -> :targets
          _ -> :rest
        end
      end)

    targets = Map.new(targets)

    Enum.reduce(starters, 1, fn {start, _}, lcm ->
      Helpers.lcm(lcm, count_hops(moves, start, targets, mapping, 0))
    end)
  end
end
