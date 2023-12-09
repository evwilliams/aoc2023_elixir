defmodule Day8Test do
  use ExUnit.Case

  test "part1" do
    assert Day8.part1("day8sample.txt") == 2
    assert Day8.part1("day8.txt") == 12599
  end

  test "part2" do
    assert Day8.part2("day8sample2.txt") == 6
    assert Day8.part2("day8.txt") == 8_245_452_805_243
  end
end
