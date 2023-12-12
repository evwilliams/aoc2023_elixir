
Benchee.run(
  %{
    "part1" => fn -> Day11.part1("day11.txt") end,
    "part2" => fn -> Day11.part2("day11.txt") end,
  },
  memory_time: 2
)
