defmodule Day4Test do
  use ExUnit.Case

  test "part1" do
    assert Day4.part1("day4sample.txt") == 13
    assert Day4.part1("day4.txt") == 23_678
  end

  test "part2" do
    assert Day4.part2("day4sample.txt") == 30
    assert Day4.part2("day4.txt") == 15_455_663
  end
end
