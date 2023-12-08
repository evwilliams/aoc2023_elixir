
Benchee.run(
  %{
    "part1" => fn -> Day5.part1("day5.txt") end,
    "part2" => fn -> Day5.part2("day5.txt") end,
  },
  memory_time: 2
)
