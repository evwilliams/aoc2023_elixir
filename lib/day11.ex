defmodule Day11 do
  def distance({r1, c1}, {r2, c2}) do
    abs(c2 - c1) + abs(r2 - r1)
  end

  def distances([], acc), do: acc

  def distances([start | galaxies], acc) do
    acc =
      Enum.map(galaxies, fn g ->
        distance(start, g)
      end)
      |> Enum.concat(acc)

    distances(galaxies, acc)
  end

  def solve(filename, expansion_amount) do
    original_grid =
      Helpers.stream_lines(filename)
      |> Helpers.character_grid()

    {{max_row, max_col}, _} = Enum.max(original_grid)

    {galaxy_coords, _} =
      Enum.filter(original_grid, fn {_, char} -> char == "#" end)
      |> Enum.unzip()

    {galaxy_rows, galaxy_cols} = Enum.unzip(galaxy_coords)
    empty_rows = Enum.reject(0..max_row, &(&1 in galaxy_rows))
    empty_cols = Enum.reject(0..max_col, &(&1 in galaxy_cols))

    galaxy_coords =
      galaxy_coords
      |> Enum.map(fn {row, col} ->
        row = row + Enum.count(empty_rows, &(&1 < row)) * expansion_amount
        col = col + Enum.count(empty_cols, &(&1 < col)) * expansion_amount
        {row, col}
      end)

    distances(galaxy_coords, [])
    |> Enum.sum()
  end

  def part1(filename) do
    solve(filename, 1)
  end

  def part2(filename) do
    solve(filename, 1_000_000 - 1)
  end
end
