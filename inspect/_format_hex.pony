
use "format"

primitive _FormatHex
  fun apply[A: (Int & Integer[A])](input: A): String iso^ =>
    Format.int[A](input, FormatHexBare)
