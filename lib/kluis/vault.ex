defmodule Kluis.Vault do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @correct_tally "teamwork"

  def handle_key(tally, "Backspace"), do: {:ok, String.slice(tally, 0..-2)}
  def handle_key(tally, key) do
    if only_single_lowercase(key) && !correct?(tally) do
      case expected_key(tally) do
        ^key -> {:ok,    tally <> key}
        _    -> {:wrong, tally}
      end
    else
      {:ignored, tally}
    end
  end

  def expected_key(""), do: String.first(@correct_tally)
  def expected_key(tally) do
    @correct_tally
    |> String.trim(tally)
    |> String.first()
  end

  def correct?(tally), do: tally == @correct_tally

  @spec characters_left(binary) :: non_neg_integer
  def characters_left(tally) do
    max(
      String.length(@correct_tally) - String.length(tally),
      0
    )
  end

  defp only_single_lowercase(<<c::utf8>>), do: c in ?a..?z

end
