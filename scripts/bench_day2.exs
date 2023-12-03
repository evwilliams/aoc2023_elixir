
Benchee.run(
  %{
    "part1" => fn -> Day2.part1("day2.txt") end,
    "part2" => fn -> Day2.part2("day2.txt") end,
  },
  memory_time: 2
)
