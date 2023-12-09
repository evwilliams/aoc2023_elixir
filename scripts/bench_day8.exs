
Benchee.run(
  %{
    "part1" => fn -> Day8.part1("day8.txt") end,
    "part2" => fn -> Day8.part2("day8.txt") end,
  },
  memory_time: 2
)
