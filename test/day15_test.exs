defmodule Day15Test do
  use ExUnit.Case

  test "part1" do
    assert Day15.part1("Day15sample.txt") == 1320
    assert Day15.part1("Day15.txt") == 501_680
  end

  test "part2" do
    assert Day15.part2("Day15sample.txt") == 145
    assert Day15.part2("Day15.txt") == 241_094
  end
end
