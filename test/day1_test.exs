defmodule Day1Test do
  use ExUnit.Case

  test "part1" do
    assert Day1.part1("day1a_sample.txt") == 142
    assert Day1.part1("day1.txt") == 55090
  end

  test "part2" do
    assert Day1.part2("day1b_sample.txt") == 281
    assert Day1.part2("day1.txt") == 54845
  end
end
