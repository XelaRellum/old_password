defmodule OldPassword.Math32 do
  use Bitwise, skip_operators: true

  @moduledoc """
  Add bitwise and mathematical operations that are limited to 32 bits.
  """

  @doc """
  Convert an integer to a 0 padded hex-string

  ## Examples

      iex> OldPassword.Math32.to_hex(0)
      "00000000"

      iex> OldPassword.Math32.to_hex(-1)
      "ffffffff"

      iex> OldPassword.Math32.to_hex(15)
      "0000000f"
  """
  def to_hex(v) do
    v
    |> band(0xFFFFFFFF)
    |> Integer.to_string(16)
    |> String.downcase()
    |> String.pad_leading(8, "0")
  end

  @doc """
  Bitwise and

  ## Examples

      iex> OldPassword.Math32.and32(1, 2)
      0

      iex> OldPassword.Math32.and32(-1, 1)
      1
  """
  def and32(a, b),
    do:
      band(a, b)
      |> cut32

  @doc """
  Add function that returns maximum 32 bits.

  ## Examples

      iex> OldPassword.Math32.add(1, 2)
      3

      iex> OldPassword.Math32.add(-1, 2)
      1

      iex> OldPassword.Math32.add(-1, 0)
      0xFFFFFFFF
  """
  def add(a, b),
    do:
      (a + b)
      |> cut32

  @doc """
  Multiply two values and limit result to 32 bits.

  ## Examples

      iex> OldPassword.Math32.mul(2, 3)
      6
      iex> OldPassword.Math32.mul(0x80000000, 2) # overrun
      0
  """
  def mul(a, b),
    do:
      (a * b)
      |> cut32

  @doc """
  Limit a value to 32 bits.

  ## Examples

      iex> OldPassword.Math32.cut32(0x1FFFFFFFF) # 33 bits
      4294967295
  """
  def cut32(v), do: band(v, 0xFFFFFFFF)

  @doc """
  Shift a value bitwise left.

  ## Examples

      iex> OldPassword.Math32.sleft(1, 1)
      2

      iex> OldPassword.Math32.sleft(1, 31)
      2147483648

      iex> OldPassword.Math32.sleft(0x80000000, 1) # overrun
      0
  """
  def sleft(v, by),
    do:
      Bitwise.bsl(v, by)
      |> cut32

  @doc """
  Bitwise XOR

  ## Examples

      iex> OldPassword.Math32.xor(1, 2)
      3

      iex> OldPassword.Math32.xor(1, 1)
      0

      iex> OldPassword.Math32.xor(-1, 1)
      4294967294
  """
  def xor(a, b),
    do:
      bxor(cut32(a), cut32(b))
      |> cut32
end
