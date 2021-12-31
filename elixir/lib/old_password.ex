defmodule OldPassword do
  @moduledoc """
  Elixir implementation of `old_password`.
  """
  use Bitwise

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
    nr = bxor(nr, ((nr &&& 63) + add) * tmp + (nr <<< 8))

    # nr2 += (nr2 << 8) ^ nr;
    nr2 = nr2 + bxor(nr2 <<< 8, nr)
    # add += tmp;
    add = add + tmp

    old_password(t, nr, add, nr2)
  end

  defp old_password([], nr, _add, nr2) do
    # result[0] = nr & (((ulong)1L << 31) - 1L); /* Don't use sign bit (str2int) */
    result0 = nr &&& 0x7FFFFFFF

    # result[1] = nr2 & (((ulong)1L << 31) - 1L);
    result1 = nr2 &&& 0x7FFFFFFF

    to_hex(result0) <> to_hex(result1)
  end

  defp to_hex(v) do
    v
    |> band(0xFFFFFFFF)
    |> Integer.to_string(16)
    |> String.downcase()
    |> String.pad_leading(8, "0")
  end
end
