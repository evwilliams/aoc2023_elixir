
Benchee.run(
  %{
    "part1" => fn -> Day4.part1("day4.txt") end,
    "part2" => fn -> Day4.part2("day4.txt") end,
  },
  memory_time: 2
)
