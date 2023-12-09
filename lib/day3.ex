defmodule Day3 do
  def clamp_range(first..last, max_val) do
    max(0, first)..min(last, max_val)
  end

  def adjacents({row, str_start, str_after}, {grid, {max_row, max_col}}) do
    row_range = clamp_range(Range.shift(-1..1, row), max_row)
    col_range = clamp_range((str_start - 1)..str_after, max_col)

    for r <- row_range, c <- col_range do
      {unless r == row and c in str_start..(str_after - 1) do
         Enum.at(Enum.at(grid, r), c)
       end, {r, c}}
    end
  end

  def parse(filename) do
    lines = Helpers.stream_lines(filename)
    grid = Enum.map(lines, &String.graphemes/1)
    max_row = Enum.count(grid) - 1
    [first_row | _] = grid
    max_col = Enum.count(first_row) - 1

    numbers =
      Enum.with_index(lines)
      |> Enum.map(fn {line, row} ->
        Regex.scan(~r"\d+", line, return: :index)
        |> List.flatten()
        |> Enum.map(fn {str_start, len} ->
          {String.to_integer(String.slice(line, str_start, len)),
           {row, str_start, str_start + len}}
        end)
      end)
      |> List.flatten()

    {numbers, {grid, {max_row, max_col}}}
  end

  def part1(filename) do
    {numbers, grid_info} = parse(filename)

    Enum.reduce(numbers, 0, fn {number, location}, sum ->
      if Enum.any?(adjacents(location, grid_info), fn {char, _} ->
           char != "." and not is_nil(char)
         end),
         do: sum + number,
         else: sum
    end)
  end

  def part2(filename) do
    {numbers, grid_info} = parse(filename)

    Enum.map(numbers, fn {number, location} ->
      adjacents(location, grid_info)
      |> Stream.map(fn {char, coords} -> if char == "*", do: {coords, number} end)
      |> Enum.reject(&is_nil/1)
    end)
    |> List.flatten()
    |> Enum.group_by(fn {key, _} -> key end, fn {_, num} -> num end)
    |> Stream.map(fn {_, nums} -> if Enum.count(nums) == 2, do: Enum.product(nums), else: 0 end)
    |> Enum.sum()
  end
end
