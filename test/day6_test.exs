defmodule Day6Test do
  use ExUnit.Case

  test "part1" do
    assert Day6.part1("day6sample.txt") == 288
    assert Day6.part1("day6.txt") == 449_820
  end

  test "part2" do
    assert Day6.part2("day6sample.txt") == 71503
    assert Day6.part2("day6.txt") == 42_250_895
  end
end
