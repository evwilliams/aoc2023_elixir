
Benchee.run(
  %{
    "part1" => fn -> Day9.part1("day9.txt") end,
    "part2" => fn -> Day9.part2("day9.txt") end,
  },
  memory_time: 2
)
