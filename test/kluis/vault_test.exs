defmodule Kluis.VaultTest do
  use ExUnit.Case, async: true

  alias Kluis.Vault

  test "expected_key" do
    assert Vault.expected_key("")         == "t"
    assert Vault.expected_key("t")        == "e"
    assert Vault.expected_key("te")       == "a"
    assert Vault.expected_key("tea")      == "m"
    assert Vault.expected_key("team")     == "w"
    assert Vault.expected_key("teamw")    == "o"
    assert Vault.expected_key("teamwo")   == "r"
    assert Vault.expected_key("teamwor")  == "k"
    assert Vault.expected_key("teamwork") == nil
  end

  test "add_key, success" do
    assert Vault.add_key("",        "t") == {:ok, "t"}
    assert Vault.add_key("t",       "e") == {:ok, "te"}
    assert Vault.add_key("te",      "a") == {:ok, "tea"}
    assert Vault.add_key("tea",     "m") == {:ok, "team"}
    assert Vault.add_key("team",    "w") == {:ok, "teamw"}
    assert Vault.add_key("teamw",   "o") == {:ok, "teamwo"}
    assert Vault.add_key("teamwo",  "r") == {:ok, "teamwor"}
    assert Vault.add_key("teamwor", "k") == {:ok, "teamwork"}
  end

  test "add_key, ignore" do
    assert Vault.add_key("",    "t") == {:ok,    "t"}
    assert Vault.add_key("t",   "e") == {:ok,    "te"}
    assert Vault.add_key("te",  "a") == {:ok,    "tea"}
    assert Vault.add_key("tea", "a") == {:error, "tea"}
    assert Vault.add_key("tea", "e") == {:error, "tea"}
    assert Vault.add_key("tea", "x") == {:error, "tea"}
    assert Vault.add_key("tea", "m") == {:ok,    "team"}
  end

  test "correct?" do
    assert Vault.correct?("teamwork")
    refute Vault.correct?("teamwor")
    refute Vault.correct?("junk")
    refute Vault.correct?("")
    refute Vault.correct?(nil)
  end

end
