defmodule OldPassword do
  @moduledoc """
  Elixir implementation of `old_password`.
  """
  alias OldPassword.Math32

  @doc """
  Create a legacy hash from a password.

  ## Examples

      iex> OldPassword.old_password(nil)
      :nil

      iex> OldPassword.old_password("")
      ""

      iex> OldPassword.old_password("a")
      "60671c896665c3fa"

      iex> OldPassword.old_password("abc")
      "7cd2b5942be28759"
  """
  def old_password(nil), do: nil
  def old_password(""), do: ""

  def old_password(password) when is_binary(password) do
    # convert the string to a utf-8 encoded byte list
    password
    |> :binary.bin_to_list()
    |> old_password()
  end

  def old_password(password) do
    old_password(password, 1_345_345_333, 7, 0x12345671)
  end

  defp old_password([32 | t], nr, add, nr2), do: old_password(t, nr, add, nr2)
  defp old_password([9 | t], nr, add, nr2), do: old_password(t, nr, add, nr2)

  defp old_password([h | t], nr, add, nr2) do
    tmp = h
    # nr ^= (((nr & 63) + add) * tmp) + (nr << 8)
    nr =
      Math32.xor(
        nr,
        Math32.add(Math32.mul(Math32.add(Math32.and32(nr, 63), add), tmp), Math32.sleft(nr, 8))
      )

    # nr2 += (nr2 << 8) ^ nr;
    nr2 = Math32.add(nr2, Math32.xor(Math32.sleft(nr2, 8), nr))
    # add += tmp;
    add = Math32.add(add, tmp)

    old_password(t, nr, add, nr2)
  end

  defp old_password([], nr, _add, nr2) do
    # result[0] = nr & (((ulong)1L << 31) - 1L); /* Don't use sign bit (str2int) */
    result0 = Math32.and32(nr, 0x7FFFFFFF)

    # result[1] = nr2 & (((ulong)1L << 31) - 1L);
    result1 = Math32.and32(nr2, 0x7FFFFFFF)

    Math32.to_hex(result0) <> Math32.to_hex(result1)
  end
end
