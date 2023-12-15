defmodule Day15 do
  def hash(text), do: hash(text, 0)
  def hash(<<>>, acc), do: acc

  def hash(<<char, rest::binary>>, acc) do
    hash(rest, rem((acc + char) * 17, 256))
  end

  def upsert(box, key, value) do
    if Map.has_key?(box, key) do
      Map.update!(box, key, &%{&1 | value: value})
    else
      box = Map.update(box, :sort_key, 0, &(&1 + 1))
      sort_key = Map.get(box, :sort_key, 0)
      Map.put(box, key, %{value: value, sort_key: sort_key})
    end
  end

  def part1(filename) do
    Helpers.read_input(filename)
    |> String.split(",")
    |> Enum.map(&hash(&1, 0))
    |> Enum.sum()
  end

  def handle_op(op, boxes) do
    [_, label, op_char, value] = Regex.run(~r"(\w+)(=|-)(\d*)", op)

    box_num = hash(label)
    box = Map.get(boxes, box_num, %{})

    box =
      case op_char do
        "-" -> Map.delete(box, label)
        "=" -> upsert(box, label, value)
      end

    Map.put(boxes, box_num, box)
  end

  def handle_ops([], boxes), do: boxes

  def handle_ops([op | ops], boxes) do
    boxes = handle_op(op, boxes)
    handle_ops(ops, boxes)
  end

  def focusing_power(boxes) do
    Enum.flat_map(boxes, fn {box_num, box} ->
      box
      |> Enum.reject(fn {key, _} -> key == :sort_key end)
      |> Enum.sort(fn {_, %{sort_key: s1}}, {_, %{sort_key: s2}} -> s1 <= s2 end)
      |> Enum.with_index()
      |> Enum.map(fn {{_, %{value: value}}, position} ->
        (box_num + 1) * (position + 1) * String.to_integer(value)
      end)
    end)
    |> Enum.sum()
  end

  def part2(filename) do
    Helpers.read_input(filename)
    |> String.split(",")
    |> then(&handle_ops(&1, %{}))
    |> then(&focusing_power(&1))
  end
end
