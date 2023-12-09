
Benchee.run(
  %{
    "part1" => fn -> Day3.part1("day3.txt") end,
    "part2" => fn -> Day3.part2("day3.txt") end,
  },
  memory_time: 2
)
