defmodule Day16 do
  def rotate(:north, :right), do: :east
  def rotate(:north, :left), do: :west
  def rotate(:east, :right), do: :south
  def rotate(:east, :left), do: :north
  def rotate(:south, :right), do: :west
  def rotate(:south, :left), do: :east
  def rotate(:west, :right), do: :north
  def rotate(:west, :left), do: :south

  def next_beam({{row, col}, :east = dir}), do: {{row, col + 1}, dir}
  def next_beam({{row, col}, :west = dir}), do: {{row, col - 1}, dir}
  def next_beam({{row, col}, :north = dir}), do: {{row - 1, col}, dir}
  def next_beam({{row, col}, :south = dir}), do: {{row + 1, col}, dir}

  def split(grid, {coords, direction}, notes) do
    traverse(grid, next_beam({coords, rotate(direction, :left)}), notes)
    |> then(&traverse(grid, next_beam({coords, rotate(direction, :right)}), &1))
  end

  def bend(grid, {coords, direction}, rotation, notes) do
    traverse(grid, next_beam({coords, rotate(direction, rotation)}), notes)
  end

  def valid_coords?({row, col}, {max_row, max_col}) do
    row in 0..max_row and col in 0..max_col
  end

  def traverse(_, beam, notes) when is_map_key(notes, beam), do: notes

  def traverse({grid_map, dimensions} = grid, {coords, direction} = beam, notes) do
    if valid_coords?(coords, dimensions) do
      notes = Map.put(notes, beam, 1)
      char = Map.get(grid_map, coords)

      cond do
        char == "|" and direction in [:east, :west] ->
          split(grid, beam, notes)

        char == "-" and direction in [:north, :south] ->
          split(grid, beam, notes)

        char == "/" and direction in [:north, :south] ->
          bend(grid, beam, :right, notes)

        char == "/" and direction in [:east, :west] ->
          bend(grid, beam, :left, notes)

        char == "\\" and direction in [:north, :south] ->
          bend(grid, beam, :left, notes)

        char == "\\" and direction in [:east, :west] ->
          bend(grid, beam, :right, notes)

        true ->
          traverse(grid, next_beam(beam), notes)
      end
    else
      notes
    end
  end

  def num_activations(grid_info, entrance, direction) do
    {visited_coords, _} =
      traverse(grid_info, {entrance, direction}, %{})
      |> Map.keys()
      |> Enum.unzip()

    Enum.uniq(visited_coords)
    |> Enum.count()
  end

  def part1(filename) do
    Helpers.read_input(filename, of: &Helpers.lines/1)
    |> Helpers.character_grid()
    |> then(fn grid ->
      {dimensions, _} = Enum.max(grid)
      {grid, dimensions}
    end)
    |> num_activations({0, 0}, :east)
  end

  def entrance_coords({max_row, max_col}) do
    vertical = for row <- 0..max_row, do: [{{row, 0}, :east}, {{row, max_col}, :west}]
    horizontal = for col <- 0..max_col, do: [{{0, col}, :south}, {{max_row, col}, :north}]

    List.flatten(vertical ++ horizontal)
  end

  def part2(filename) do
    {grid, dimensions} =
      Helpers.read_input(filename, of: &Helpers.lines/1)
      |> Helpers.character_grid()
      |> then(fn grid ->
        {dimensions, _} = Enum.max(grid)
        {grid, dimensions}
      end)

    entrance_coords(dimensions)
    |> Enum.map(fn {entrance, direction} ->
      num_activations({grid, dimensions}, entrance, direction)
    end)
    |> Enum.max()
  end
end
