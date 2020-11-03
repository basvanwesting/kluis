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

  test "handle_key, success" do
    assert Vault.handle_key("",        "t") == {:ok, "t"}
    assert Vault.handle_key("t",       "e") == {:ok, "te"}
    assert Vault.handle_key("te",      "a") == {:ok, "tea"}
    assert Vault.handle_key("tea",     "m") == {:ok, "team"}
    assert Vault.handle_key("team",    "w") == {:ok, "teamw"}
    assert Vault.handle_key("teamw",   "o") == {:ok, "teamwo"}
    assert Vault.handle_key("teamwo",  "r") == {:ok, "teamwor"}
    assert Vault.handle_key("teamwor", "k") == {:ok, "teamwork"}
  end

  test "handle_key, wrong" do
    assert Vault.handle_key("",    "t") == {:ok,    "t"}
    assert Vault.handle_key("t",   "e") == {:ok,    "te"}
    assert Vault.handle_key("te",  "a") == {:ok,    "tea"}
    assert Vault.handle_key("tea", "a") == {:wrong, "tea"}
    assert Vault.handle_key("tea", "e") == {:wrong, "tea"}
    assert Vault.handle_key("tea", "x") == {:wrong, "tea"}
    assert Vault.handle_key("tea", "m") == {:ok,    "team"}
  end

  test "handle_key, ignore" do
    assert Vault.handle_key("",         "t") == {:ok,      "t"}
    assert Vault.handle_key("t",        "e") == {:ok,      "te"}
    assert Vault.handle_key("te",       "a") == {:ok,      "tea"}
    assert Vault.handle_key("tea",      "/") == {:ignored, "tea"}
    assert Vault.handle_key("tea",      "?") == {:ignored, "tea"}
    assert Vault.handle_key("teamwork", "e") == {:ignored, "teamwork"}
  end

  test "handle_key, Backspace" do
    assert Vault.handle_key("",         "t")         == {:ok,      "t"}
    assert Vault.handle_key("t",        "e")         == {:ok,      "te"}
    assert Vault.handle_key("te",       "a")         == {:ok,      "tea"}
    assert Vault.handle_key("tea",      "a")         == {:wrong,   "tea"}
    assert Vault.handle_key("tea",      "Backspace") == {:ok,      "te"}
    assert Vault.handle_key("te",       "Backspace") == {:ok,      "t"}
    assert Vault.handle_key("t",        "Backspace") == {:ok,      ""}
    assert Vault.handle_key("",         "Backspace") == {:ok,      ""}
    assert Vault.handle_key("teamwork", "Backspace") == {:ignored, "teamwork"}
  end

  test "correct?" do
    assert Vault.correct?("teamwork")
    refute Vault.correct?("teamwor")
    refute Vault.correct?("junk")
    refute Vault.correct?("")
    refute Vault.correct?(nil)
  end

  test "characters_left" do
    assert Vault.characters_left("")           == 8
    assert Vault.characters_left("t")          == 7
    assert Vault.characters_left("te")         == 6
    assert Vault.characters_left("tea")        == 5
    assert Vault.characters_left("team")       == 4
    assert Vault.characters_left("teamw")      == 3
    assert Vault.characters_left("teamwo")     == 2
    assert Vault.characters_left("teamwor")    == 1
    assert Vault.characters_left("teamwork")   == 0
    assert Vault.characters_left("impossible") == 0
  end

end
