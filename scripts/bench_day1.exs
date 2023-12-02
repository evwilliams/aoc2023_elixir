
Benchee.run(
  %{
    "part1" => fn -> Day1.part1("day1.txt") end,
    "part2" => fn -> Day1.part2("day1.txt") end,
  },
  memory_time: 2
)
