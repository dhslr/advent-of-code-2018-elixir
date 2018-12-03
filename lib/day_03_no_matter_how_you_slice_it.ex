defmodule Adventofcode.Day03NoMatterHowYouSliceIt do
  use Adventofcode

  @enforce_keys [:id, :offset, :size, :fabric]
  defstruct id: nil, offset: nil, size: nil, fabric: nil

  @claim_regex ~r/^\#(?<id>\d+)\s\@\s(?<left>\d+),(?<top>\d+):\s(?<width>\d+)x(?<height>\d+)$/

  def parse_claim(claim_text) do
    captures = Regex.named_captures(@claim_regex, claim_text)

    %{"id" => id, "left" => left, "top" => top, "width" => width, "height" => height} = captures

    id = String.to_integer(id)
    left = String.to_integer(left)
    top = String.to_integer(top)
    width = String.to_integer(width)
    height = String.to_integer(height)

    fabric =
      Enum.flat_map(top..(top + height - 1), fn y ->
        Enum.map(left..(left + width - 1), fn x ->
          {x, y}
        end)
      end)

    %__MODULE__{id: id, offset: {left, top}, size: {width, height}, fabric: fabric}
  end

  def overlapping_fabric(input) do
    input
    |> String.trim_trailing("\n")
    |> String.split("\n")
    |> Enum.map(&parse_claim/1)
    |> combine_claims
    |> Enum.filter(fn {_pos, count} -> count >= 2 end)
    |> length
  end

  defp combine_claims(claims) do
    Enum.reduce(claims, %{}, fn claim, acc ->
      Enum.reduce(claim.fabric, acc, fn pos, acc ->
        Map.update(acc, pos, 1, &(&1 + 1))
      end)
    end)
  end
end
