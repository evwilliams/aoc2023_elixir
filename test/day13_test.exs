defmodule Day13Test do
  use ExUnit.Case

  test "transposing twice should give original" do
    paragraph =
      Helpers.read_input("day13.txt", of: &Helpers.paragraphs/1)
      |> Enum.map(fn paragraph ->
        Helpers.lines(paragraph)
      end)

    assert true ==
             Enum.all?(paragraph, fn lines ->
               transposed_twice_lines =
                 Helpers.character_grid(lines)
                 |> Day13.transpose_grid()
                 |> Day13.grid_to_lines()
                 |> Helpers.lines()
                 |> Helpers.character_grid()
                 |> Day13.transpose_grid()
                 |> Day13.grid_to_lines()
                 |> Helpers.lines()

               lines == transposed_twice_lines
             end)
  end

  test "all smudges should have same length" do
    paragraphs =
      Helpers.read_input("day13.txt", of: &Helpers.paragraphs/1)
      |> Enum.map(fn paragraph ->
        Helpers.lines(paragraph)
      end)

    assert true ==
             Enum.all?(paragraphs, fn paragraph ->
               1 ==
                 [paragraph | Day13.all_smudge_options(Enum.join(paragraph, "\n"))]
                 |> Enum.map(&Enum.join(&1, "\n"))
                 |> Enum.map(&String.length/1)
                 |> MapSet.new()
                 |> Enum.count()
             end)
  end
end
