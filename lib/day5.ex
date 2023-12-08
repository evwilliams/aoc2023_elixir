defmodule Day5 do
  def range_from_pair([start, len]), do: start..(start + len)

  def ranges_from_trio([dest_start, src_start, len]) do
    {dest_start..(dest_start + len), src_start..(src_start + len)}
  end

  def parse_input(input) do
    [[seed_nums] | almanac] =
      Helpers.paragraphs(input)
      |> Enum.map(&Helpers.string_after(&1, ":"))
      |> Enum.map(&Helpers.split_lines/1)
      |> Helpers.nested_map(&Helpers.ints/1)

    {seed_nums, Helpers.nested_map(almanac, &ranges_from_trio/1)}
  end

  def shift_to_destination(range, {dest_start.._, src_start.._}) do
    Range.shift(range, dest_start - src_start)
  end

  def range_intersection(r1_start..r1_end, r2_start..r2_end) do
    Range.new(max(r1_start, r2_start), min(r1_end, r2_end))
  end

  def valid_range?(r_start..r_end), do: r_start < r_end

  def convert_seed(seed, {dest_start.._, src_start.._}), do: seed + dest_start - src_start

  def find_locations(seeds, []), do: seeds

  def find_locations(seeds, [category | almanac]) do
    Enum.map(seeds, fn seed ->
      Enum.find_value(category, seed, fn {_, src_range} = ranges ->
        if seed in src_range, do: convert_seed(seed, ranges)
      end)
    end)
    |> find_locations(almanac)
  end

  def part1(filename) do
    {seeds, almanac} = parse_input(Helpers.read_input(filename))
    Enum.min(find_locations(seeds, almanac))
  end

  # Part 2

  def partition_range(seed_start..seed_end = seed_range, src_range) do
    overlap = range_intersection(seed_range, src_range)

    if not valid_range?(overlap) do
      {nil, [seed_range]}
    else
      o_start..o_end = overlap
      non_overlap = Enum.filter([seed_start..o_start, o_end..seed_end], &valid_range?/1)
      {overlap, non_overlap}
    end
  end

  def convert_seed_ranges([], _, acc), do: acc
  def convert_seed_ranges(seed_ranges, [], acc), do: Enum.concat(seed_ranges, acc)

  def convert_seed_ranges(seed_ranges, [{dest_range, src_range} | ranges], acc) do
    {overlaps, non_overlaps} =
      seed_ranges
      |> Enum.map(&partition_range(&1, src_range))
      |> Enum.unzip()

    acc =
      overlaps
      |> Enum.reject(&(is_nil(&1) or Enum.empty?(&1)))
      |> Enum.map(&shift_to_destination(&1, {dest_range, src_range}))
      |> Enum.concat(acc)

    non_overlaps
    |> List.flatten()
    |> Enum.reject(&(is_nil(&1) or Enum.empty?(&1)))
    |> convert_seed_ranges(ranges, acc)
  end

  def find_location_ranges(seed_ranges, []), do: seed_ranges

  def find_location_ranges(seed_ranges, [category | almanac]) do
    seed_ranges
    |> convert_seed_ranges(category, [])
    |> find_location_ranges(almanac)
  end

  def part2(filename) do
    {seed_nums, almanac} = parse_input(Helpers.read_input(filename))

    Enum.chunk_every(seed_nums, 2)
    |> Enum.map(&range_from_pair/1)
    |> find_location_ranges(almanac)
    |> Enum.map(fn start.._ -> start end)
    |> Enum.min()
  end
end
