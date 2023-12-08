
Benchee.run(
  %{
    "part1" => fn -> Day6.part1("day6.txt") end,
    "part2" => fn -> Day6.part2("day6.txt") end,
  },
  memory_time: 2
)
