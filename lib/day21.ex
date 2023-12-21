defmodule Day21 do
  # This used to be split across functions, but tried optimizing away a bunch.
  # Still way too slow even for part 1
  def walk({grid_map, {max_row, max_col}} = grid, locs, final_locs) do
    if Enum.count(locs) == 0 do
      final_locs
    else
      [{{row, col} = loc, [num_steps | rest]}] =
        Enum.take(locs, 1)

      locs =
        if rest == [] do
          Map.delete(locs, loc)
        else
          Map.replace(locs, loc, rest)
        end

      if num_steps == 0 do
        walk(grid, locs, [loc | final_locs])
      else
        next_locs =
          [
            {row, col + 1},
            {row, col - 1},
            {row - 1, col},
            {row + 1, col}
          ]
          |> Enum.filter(fn coords ->
            Map.get(grid_map, coords) != "#" and row in 0..max_row and col in 0..max_col
          end)
          |> Enum.map(fn coords -> {coords, [num_steps - 1]} end)
          |> Map.new()

        locs = Map.merge(locs, next_locs, fn _, list, [single] -> [single | list] end)

        walk(grid, locs, final_locs)
      end
    end
  end

  # Too slow, only worked for the sample map and small step counts. Left for posterity
  # Only fast enough for num_steps <= 10
  def part1_too_slow(filename, num_steps) do
    grid =
      Helpers.read_input(filename, of: &Helpers.lines/1)
      |> Helpers.character_grid()

    {dims, _} = Enum.max(grid)
    {s_loc, _} = Enum.find(grid, fn {_, v} -> v == "S" end)

    walk({grid, dims}, %{s_loc => [num_steps]}, [])
    |> Enum.uniq()
    |> Enum.count()
  end

  # Fine for num_steps <= 64
  def part1(filename, num_steps) do
    grid =
      Helpers.read_input(filename, of: &Helpers.lines/1)
      |> Helpers.character_grid()

    {{max_rows, max_cols}, _} = Enum.max(grid)

    grid_mask =
      for row <- 0..max_rows, col <- 0..max_cols do
        if Map.get(grid, {row, col}) == "#", do: 0, else: 1
      end
      |> Nx.u8()
      |> Nx.reshape({1, 1, max_rows + 1, max_cols + 1})

    loc_tensor =
      for row <- 0..max_rows, col <- 0..max_cols do
        if Map.get(grid, {row, col}) == "S", do: 1, else: 0
      end
      |> Nx.u8()
      |> Nx.reshape({1, 1, max_rows + 1, max_cols + 1})

    neighbor_mask =
      Nx.u8([0, 1, 0, 1, 0, 1, 0, 1, 0])
      |> Nx.reshape({1, 1, 3, 3})

    Enum.reduce(1..num_steps, loc_tensor, fn _, loc_tensor ->
      Nx.multiply(grid_mask, Nx.conv(loc_tensor, neighbor_mask, padding: :same))
    end)
    |> Nx.to_flat_list()
    |> Enum.count(&(&1 > 0))
  end

  # TODO - Somehow make this work for num_steps = 26_501_365 and infinitely repeating boards
  # Obviously a completely different approach is needed
  def part2(filename, num_steps) do
    {filename, num_steps}
  end
end
