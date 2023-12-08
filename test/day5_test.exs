defmodule Day5Test do
  use ExUnit.Case

  test "part1" do
    assert Day5.part1("day5sample.txt") == 35
    assert Day5.part1("day5.txt") == 389_056_265
  end

  test "part2" do
    assert Day5.part2("day5sample.txt") == 46
    assert Day5.part2("day5.txt") == 137_516_820
  end
end
