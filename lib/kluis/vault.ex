defmodule Kluis.Vault do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @correct_tally "teamwork"

  def add_key(tally, key) do
    case expected_key(tally) do
      ^key -> {:ok,    tally <> key}
      _    -> {:error, tally}
    end
  end

  def expected_key("") do
    @correct_tally
    |> String.first()
  end
  def expected_key(tally) do
    @correct_tally
    |> String.trim(tally)
    |> String.first()
  end

  def correct?(tally), do: tally == @correct_tally

end
