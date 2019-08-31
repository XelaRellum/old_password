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
end
