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

  def shared_indexes([first | rest]) do
    Enum.map(first, fn index ->
      if Enum.all?(rest, &(index in &1)), do: index, else: nil
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

  def solve(lines) do
    vertical_splits =
      Enum.map(lines, fn line ->
        mirror_indexes(line)
      end)
      |> shared_indexes()

    horizontal_splits =
      lines
      |> Helpers.character_grid()
      |> transpose_grid()
      |> grid_to_lines()
      |> Helpers.lines()
      |> then(fn puzzle ->
        Enum.map(puzzle, fn line ->
          mirror_indexes(line)
        end)
        |> shared_indexes()
      end)

    {Enum.reject(vertical_splits, &is_nil/1), Enum.reject(horizontal_splits, &is_nil/1)}
  end

  def smudge(paragraph, at: offset) do
    new_char =
      case String.at(paragraph, offset) do
        "#" -> "."
        "." -> "#"
      end

    head = if offset > 0, do: String.slice(paragraph, 0..(offset - 1)), else: ""
    tail = String.slice(paragraph, (offset + 1)..(offset + String.length(paragraph)))

    head <> new_char <> tail
  end

  def pick_smudge({options, blocked_solution}) do
    pick_smudge(options, blocked_solution)
  end

  def pick_smudge([paragraph | options], {blocked_v, blocked_h} = blocked) do
    {v_splits, h_splits} = solve(paragraph)
    v_splits = v_splits -- blocked_v
    h_splits = h_splits -- blocked_h

    if {v_splits, h_splits} == {[], []} do
      pick_smudge(options, blocked)
    else
      {Enum.find_value(v_splits, & &1), Enum.find_value(h_splits, & &1)}
    end
  end

  def part1(filename) do
    Helpers.read_input(filename, of: &Helpers.paragraphs/1)
    |> Enum.map(fn paragraph ->
      Helpers.lines(paragraph)
    end)
    |> Enum.map(&solve/1)
    |> IO.inspect()
    |> Enum.map(fn {v_splits, h_splits} ->
      {Enum.find_value(v_splits, & &1), Enum.find_value(h_splits, & &1)}
    end)
    |> IO.inspect()
    |> Enum.map(fn {v, h} -> v || h * 100 end)
    |> Enum.sum()
  end

  def all_smudge_options(paragraph) do
    Enum.reject(0..(String.length(paragraph) - 1), fn offset ->
      String.at(paragraph, offset) == "\n"
    end)
    |> Enum.map(fn offset ->
      smudge(paragraph, at: offset)
      |> Helpers.lines()
    end)
  end

  def part2(filename) do
    Helpers.read_input(filename, of: &Helpers.paragraphs/1)
    |> Enum.map(fn paragraph ->
      {v, h} =
        Helpers.lines(paragraph)
        |> solve()
        |> then(fn {v_splits, h_splits} ->
          {Enum.find_value(v_splits, & &1), Enum.find_value(h_splits, & &1)}
        end)

      {all_smudge_options(paragraph), {[v], [h]}}
    end)
    |> Enum.map(&pick_smudge/1)
    |> Enum.map(fn {v, h} -> v || h * 100 end)
    |> Enum.sum()
  end
end
