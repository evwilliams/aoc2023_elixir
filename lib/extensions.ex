defmodule Extensions.Enum do
  def trimmed_map(enum, fun) do
    Enum.map(enum, fun)
    |> Enum.reject(&is_nil/1)
  end
end

defmodule Extensions.Stream do
  def trimmed_map(stream, fun) do
    Stream.map(stream, fun)
    |> Stream.reject(&is_nil/1)
  end
end
