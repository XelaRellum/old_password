defmodule OldPasswordTest do
  use ExUnit.Case
  doctest OldPassword

  test "a" do
    assert OldPassword.old_password("a") == "60671c896665c3fa"
  end

  test "spaces in passwords are skipped" do
    assert OldPassword.old_password("pass word") == OldPassword.old_password("password")
  end

  test "tabs in passwords are skipped" do
    assert OldPassword.old_password("pass\tword") == OldPassword.old_password("password")
  end

  test "umlaut as utf-8" do
    assert OldPassword.old_password("ä") == "0751368d49315f7f"
  end

  test "passwords in testdata" do
    File.stream!("../testdata.csv")
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&String.split(&1, ";"))
    |> Stream.map(&test_password(&1))
    |> Stream.run()
  end

  defp test_password([password, expected_hash]) do
    hash =
      password
      |> OldPassword.old_password()

    assert hash == expected_hash
  end
end
