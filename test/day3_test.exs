defmodule Day3Test do
  use ExUnit.Case

  test "part1" do
    assert Day3.part1("day3sample.txt") == 4361
    assert Day3.part1("day3.txt") == 537_732
  end

  test "part2" do
    assert Day3.part2("day3sample.txt") == 467_835
    assert Day3.part2("day3.txt") == 84_883_664
  end
end
