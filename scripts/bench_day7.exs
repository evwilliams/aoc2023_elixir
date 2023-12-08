
Benchee.run(
  %{
    "part1" => fn -> Day7.part1("day7.txt") end,
    "part2" => fn -> Day7.part2("day7.txt") end,
  },
  memory_time: 2
)
