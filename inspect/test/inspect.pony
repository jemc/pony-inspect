
use "ponytest"
use ".."

use "collections"

class TestInspect is UnitTest
  fun name(): String => "Inspect"
  fun ref apply(h: TestHelper): TestResult =>
    
    h.expect_eq[String](Inspect(true), "true")
    h.expect_eq[String](Inspect(false), "false")
    
    h.expect_eq[String](
      Inspect("abc-\x00-def-\x09-ghi-\x10-jkl-\x19-!0123456789'\"-ABCXYZ~"),
      "\"abc-\\x00-def-\\x09-ghi-\\x10-jkl-\\x19-!0123456789'\\\"-ABCXYZ~\"",
      "String"
    )
    
    h.expect_eq[String](
      Inspect([as U8: 0, 1, 16, 65, 66, 34, 39, 126, 127, 128, 255]),
      "[0x00, 0x01, 0x10,  'A',  'B',  '\"', '\\'',  '~', 0x7F, 0x80, 0xFF]",
      "Array[U8]"
    )
    
    h.expect_eq[String](
      Inspect(List[U8].append(
        [as U8: 0, 1, 16, 65, 66, 34, 39, 126, 127, 128, 255])),
      "[0x00, 0x01, 0x10,  'A',  'B',  '\"', '\\'',  '~', 0x7F, 0x80, 0xFF]",
      "List[U8]"
    )
    
    h.expect_eq[String](
      Inspect([
        [as U8:  0,  1,  2,  3],
        [as U8:  4,  5,  6,  7],
        [as U8:  8,  9, 10, 11],
        [as U8: 12, 13, 14, 15]
      ]),
      ("[[0x00, 0x01, 0x02, 0x03], "
      + "[0x04, 0x05, 0x06, 0x07], "
      + "[0x08, 0x09, 0x0A, 0x0B], "
      + "[0x0C, 0x0D, 0x0E, 0x0F]]"),
      "Array[Array[U8]]"
    )
    
    true
