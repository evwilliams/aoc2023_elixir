defmodule Day13 do
  def mirrors?(s1, s2) do
    s1_reversed = String.reverse(s1)
    s1_len = String.length(s1)
    s2_len = String.length(s2)

    cond do
      s1_len == s2_len -> s1_reversed == s2
      s1_len > s2_len -> String.slice(s1_reversed, 0..(s2_len - 1)) == s2
      true -> String.slice(s2, 0..(s1_len - 1)) == s1_reversed
    end
  end

  def mirror_indexes(line) do
    Enum.filter(0..String.length(line), fn mid ->
      {s1, s2} = String.split_at(line, mid)
      mirrors?(s1, s2)
    end)
  end

  def find_shared_index([first | rest]) do
    Enum.find(first, fn index ->
      Enum.all?(rest, &(index in &1))
    end)
  end

  def parse(filename) do
    Helpers.read_input(filename, of: &Helpers.paragraphs/1)
    |> Enum.map(fn paragraph ->
      Helpers.lines(paragraph)
    end)
  end

  def transpose_grid(grid) do
    Enum.map(grid, fn {{r, c}, value} -> {{c, r}, value} end)
    |> Map.new()
  end

  def grid_to_lines(grid) do
    {max_row, max_col} = Enum.max(Map.keys(grid))
    grid_to_lines(grid, {0, 0}, {max_row, max_col}, "")
  end

  def grid_to_lines(grid, {row, col} = key, {max_row, max_col} = maxes, acc) do
    case {row - 1, col - 1} do
      {^max_row, _} -> acc
      {_, ^max_col} -> grid_to_lines(grid, {row + 1, 0}, maxes, acc <> "\n")
      _ -> grid_to_lines(grid, {row, col + 1}, maxes, acc <> Map.get(grid, key))
    end
  end

  def part1(filename) do
    paragraph_lines =
      parse(filename)

    vertical_splits =
      paragraph_lines
      |> Enum.map(fn puzzle ->
        Enum.map(puzzle, fn line ->
          mirror_indexes(line)
        end)
        |> find_shared_index()
      end)

    horizontal_splits =
      paragraph_lines
      |> Enum.map(&Helpers.character_grid/1)
      |> Enum.map(&transpose_grid/1)
      |> Enum.map(&grid_to_lines/1)
      |> Enum.map(&Helpers.lines/1)
      |> Enum.map(fn puzzle ->
        Enum.map(puzzle, fn line ->
          mirror_indexes(line)
        end)
        |> find_shared_index()
      end)
      |> Enum.map(&if !is_nil(&1), do: &1 * 100)

    Enum.zip(vertical_splits, horizontal_splits)
    |> Enum.map(fn {h, v} -> h || v end)
    |> Enum.sum()
  end

  def test_flips(filename) when is_binary(filename) do
    paragraph_lines = parse(filename)

    Enum.all?(paragraph_lines, fn lines ->
      test_flips(lines)
    end)
  end

  def test_flips(lines) do
    transposed_twice_lines =
      Helpers.character_grid(lines)
      |> transpose_grid()
      |> grid_to_lines()
      |> Helpers.lines()
      |> Helpers.character_grid()
      |> transpose_grid()
      |> grid_to_lines()
      |> Helpers.lines()

    lines == transposed_twice_lines
  end
end
