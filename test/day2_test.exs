defmodule Day2Test do
  use ExUnit.Case

  test "part1" do
    assert Day2.part1("day2sample.txt") == 8
    assert Day2.part1("day2.txt") == 2265
  end

  test "part2" do
    assert Day2.part2("day2sample.txt") == 2286
    assert Day2.part2("day2.txt") == 64097
  end
end
