defmodule Day19 do
  def parse_rule(<<field::utf8, ?>, rest::binary>>) do
    [num, dest] = String.split(rest, ":")
    {:gt, <<field::utf8>>, String.to_integer(num), dest}
  end

  def parse_rule(<<field::utf8, ?<, rest::binary>>) do
    [num, dest] = String.split(rest, ":")
    {:lt, <<field::utf8>>, String.to_integer(num), dest}
  end

  def parse_rule(dest), do: {:always, dest}

  def parse_rules(rules_text) do
    [_, name, rules] = Regex.run(~r"(\w+)\{(.*)\}", rules_text)

    rules =
      String.split(rules, ",")
      |> Enum.map(&parse_rule/1)

    {name, rules}
  end

  def parse_part(part_text) do
    String.split(part_text, [",", "{", "}"], trim: true)
    |> Enum.map(fn data_text ->
      [field, value] = String.split(data_text, "=")
      {field, String.to_integer(value)}
    end)
    |> Map.new()
  end

  def apply_rule(_, [{:always, dest}]), do: dest

  def apply_rule(part, [{:lt, field, value, dest} | conditions]) do
    if Map.get(part, field) < value, do: dest, else: apply_rule(part, conditions)
  end

  def apply_rule(part, [{:gt, field, value, dest} | conditions]) do
    if Map.get(part, field) > value, do: dest, else: apply_rule(part, conditions)
  end

  def evaluate_part(part, rule, rule_map) do
    next_rule = apply_rule(part, rule)

    if next_rule == "A" or next_rule == "R" do
      next_rule
    else
      evaluate_part(part, Map.get(rule_map, next_rule), rule_map)
    end
  end

  def part_value(part) do
    Enum.sum(Map.values(part))
  end

  def part1(filename) do
    [rules, parts] = Helpers.read_input(filename, of: &Helpers.paragraphs/1)

    rule_map =
      rules
      |> Helpers.lines()
      |> Enum.map(&parse_rules/1)
      |> Map.new()

    starting_rule = Map.get(rule_map, "in")

    parts
    |> Helpers.lines()
    |> Enum.map(&parse_part/1)
    |> Enum.reduce(0, fn part, sum ->
      decision = evaluate_part(part, starting_rule, rule_map)
      if decision == "A", do: sum + part_value(part), else: sum
    end)
  end

  def constrain_range_map(ranges_map, {:always, _}) do
    ranges_map
  end

  def constrain_range_map(ranges_map, {:lt, field, value, _}) do
    Map.update!(ranges_map, field, fn low.._ -> low..(value - 1) end)
  end

  def constrain_range_map(ranges_map, {:gt, field, value, _}) do
    Map.update!(ranges_map, field, fn _..high -> (value + 1)..high end)
  end

  def condition_dest({:always, dest}), do: dest
  def condition_dest({_, _, _, dest}), do: dest

  def invert_constraint({:lt, field, value, dest}), do: {:gt, field, value - 1, dest}
  def invert_constraint({:gt, field, value, dest}), do: {:lt, field, value + 1, dest}

  def walk_conditions(_, [], _), do: :tail

  def walk_conditions(ranges_map, [condition | rest], rules_map) do
    IO.inspect(condition)
    within_constraint = constrain_range_map(ranges_map, condition)

    case condition do
      {:always, "A"} ->
        {:accepted, within_constraint}

      {:always, "R"} ->
        :rejected

      {:always, dest} ->
        walk_conditions(within_constraint, Map.get(rules_map, dest), rules_map)

      {_, _, _, "A"} ->
        result1 = {:accepted, within_constraint}
        outside_constraint = constrain_range_map(ranges_map, invert_constraint(condition))
        result2 = walk_conditions(outside_constraint, rest, rules_map)
        [result1, result2]

      {_, _, _, "R"} ->
        result1 = :rejected
        outside_constraint = constrain_range_map(ranges_map, invert_constraint(condition))
        result2 = walk_conditions(outside_constraint, rest, rules_map)
        [result1, result2]

      {_, _, _, dest} ->
        result1 = walk_conditions(within_constraint, Map.get(rules_map, dest), rules_map)
        outside_constraint = constrain_range_map(ranges_map, invert_constraint(condition))
        result2 = walk_conditions(outside_constraint, rest, rules_map)
        [result1, result2]
    end
  end

  def num_possibilities(ranges_map) do
    Map.values(ranges_map)
    |> Enum.map(&Range.size/1)
    |> Enum.product()
  end

  def part2(filename) do
    [rules, _] = Helpers.read_input(filename, of: &Helpers.paragraphs/1)

    rule_map =
      rules
      |> Helpers.lines()
      |> Enum.map(&parse_rules/1)
      |> Map.new()

    starting_rule = Map.get(rule_map, "in")

    ranges_map = %{
      "x" => 1..4000,
      "m" => 1..4000,
      "a" => 1..4000,
      "s" => 1..4000
    }

    walk_conditions(ranges_map, starting_rule, rule_map)
    |> List.flatten()
    |> Enum.map(fn
      :rejected -> 0
      {:accepted, ranges_map} -> num_possibilities(ranges_map)
    end)
    |> Enum.sum()
  end
end
