
Benchee.run(
  %{
    "indexed_lines_to_grid" => fn -> Helpers.read_input("day11.txt", of: &Helpers.to_lines/1) |> Helpers.character_grid() end,
    "stream_lines_to_grid" => fn -> Helpers.stream_lines("day11.txt") |> Helpers.character_grid() end,
  },
  memory_time: 2
)
