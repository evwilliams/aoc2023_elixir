
Benchee.run(
  %{
    "part1" => fn -> Day15.part1("day15.txt") end,
    "part2" => fn -> Day15.part2("day15.txt") end,
  },
  memory_time: 2
)
