defmodule Day10 do
  def next_direction("|", from_dir), do: flip(from_dir)
  def next_direction("-", from_dir), do: flip(from_dir)
  def next_direction("L", :above), do: :right
  def next_direction("L", :right), do: :above
  def next_direction("J", :left), do: :above
  def next_direction("J", :above), do: :left
  def next_direction("7", :below), do: :left
  def next_direction("7", :left), do: :below
  def next_direction("F", :below), do: :right
  def next_direction("F", :right), do: :below

  def traverse(grid, [{{char, depth}, coords, from_dir} | pipes]) do
    next_dir = next_direction(char, from_dir)

    {{next_char, next_depth} = _, next_coords} = grid_get(grid, coords, direction: next_dir)

    if next_depth != :depth_unknown do
      next_depth
    else
      next_depth = depth + 1

      next_pipe = {next_char, next_depth}
      grid = grid_put(grid, next_coords, next_pipe)

      traverse(grid, Enum.concat(pipes, [{next_pipe, next_coords, flip(next_dir)}]))
    end
  end

  def add_coords({r1, c1}, {r2, c2}), do: {r1 + r2, c1 + c2}

  def grid_put(grid, {r, c}, value), do: put_in(grid, [r, c], value)
  def grid_get(grid, {r, c}), do: Map.get(Map.get(grid, r), c)

  def grid_get(grid, from_coords, direction: dir) do
    offset =
      case dir do
        :above -> {-1, 0}
        :left -> {0, -1}
        :right -> {0, 1}
        :below -> {1, 0}
      end

    coords = add_coords(from_coords, offset)
    {grid_get(grid, coords), coords}
  end

  def flip(:above), do: :below
  def flip(:below), do: :above
  def flip(:right), do: :left
  def flip(:left), do: :right

  def part1(filename) do
    lines = Helpers.stream_lines(filename)

    {grid, s_coords} =
      lines
      |> Enum.with_index()
      |> Enum.map(fn {line, row} ->
        chars = String.graphemes(line)
        s_col = Enum.find_index(chars, &(&1 == "S"))
        s_coords = if s_col, do: {row, s_col}, else: nil

        col_map =
          chars
          |> Enum.with_index(fn el, col -> {col, {el, :depth_unknown}} end)
          |> Map.new()

        {{row, col_map}, s_coords}
      end)
      |> Enum.unzip()

    [s_coords] = Enum.reject(s_coords, &is_nil/1)

    grid = Map.new(grid)

    # Make this generic instead of hard coded
    starting_dirs = [:left, :right]

    pipes =
      Extensions.Enum.trimmed_map(starting_dirs, fn dir ->
        case grid_get(grid, s_coords, direction: dir) do
          {nil, _} -> nil
          {{char, _}, coords} -> {{char, 1}, coords, flip(dir)}
        end
      end)
      |> Enum.reject(fn {{char, _}, _, _} -> char == "." end)

    traverse(grid, pipes)
  end

  """
  Part 2
  - Find all the pipes connected to S
  - Expand & contract the pipe coordinates (won't know which is which; use a Map/MapSet for each)
      If you hit grid boundaries, you are the expansion wave and can stop expanding that one
  - The contracting wave should keep a MapSet of all the unconnected nodes it visits as it's reduced
  - Return the number of visited unconnected nodes

  Note: The directions for expansion/contraction are the inverse of the pipe's connections
  """
end
