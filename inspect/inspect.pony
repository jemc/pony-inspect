
type _Inspectable is Any box

interface box _ReadMap[A, B]
  fun keys(): Iterator[A]^
  fun values(): Iterator[B]^

interface _StringableNoArg
  fun string(): String

interface _InspectMethodNoArg
  fun inspect(): String

interface _PeekU8Buffer
  fun size(): USize
  fun peek_u8(i: USize): U8?

primitive Inspect
  fun apply(input: _Inspectable): String val =>
    """
    Return a string with the inspect form of an object.
    The resulting string is intended for human readability and debugging,
    and is subject to change as necessary to improve future readability.
    """
    let output = recover trn String end
    
    match input
    | let x: String box =>
      output.push('"')
      let iter = x.values()
      try
        while iter.has_next() do
          let byte = iter.next()
          if byte == '"' then
            output.append("\\\"")
          elseif byte < 0x10 then
            output.append("\\x0" + _FormatHex[U8](byte))
          elseif byte < 0x20 then
            output.append("\\x" + _FormatHex[U8](byte))
          elseif byte < 0x7F then
            output.push(byte)
          else
            output.append("\\x" + _FormatHex[U8](byte))
          end
        end
      end
      output.push('"')
    | let x: ReadSeq[U8] box =>
      output.push('[')
      let iter = x.values()
      try
        while iter.has_next() do
          let byte = iter.next()
          if byte == '\'' then
            output.append("'\\''")
          elseif byte < 0x10 then
            output.append("0x0" + _FormatHex[U8](byte))
          elseif byte < 0x20 then
            output.append("0x" + _FormatHex[U8](byte))
          elseif byte < 0x7F then
            output.append(" '")
            output.push(byte)
            output.append("'")
          else
            output.append("0x" + _FormatHex[U8](byte))
          end
          if iter.has_next() then output.append("; ") end
        end
      end
      output.push(']')
    | let x: ReadSeq[_Inspectable] box =>
      output.push('[')
      let iter = x.values()
      try
        while iter.has_next() do
          output.append(apply(iter.next()))
          if iter.has_next() then output.append("; ") end
        end
      end
      output.push(']')
    | let x: _ReadMap[_Inspectable, _Inspectable] =>
      output.push('{')
      (let keys, let values) = (x.keys(), x.values())
      try
        while keys.has_next() do
          (let key, let value) = (keys.next(), values.next())
          output.append(apply(key))
          output.append("->")
          output.append(apply(value))
          if keys.has_next() then
            output.append("; ")
          end
        end
      end
      output.push('}')
    | let x: _InspectMethodNoArg box => output.append(x.inspect())
    | let x: _StringableNoArg box    => output.append(x.string())
    | let x: Stringable box          => output.append(x.string())
    | let x: _PeekU8Buffer box =>
      let ary = Array[U8]
      var i: USize = 0
      while i < x.size() do
        ary.push(try x.peek_u8(i = i + 1) else 0 end)
      end
      output.append(apply(ary))
    else
      output.>append("<uninspectable")
            .>append((digestof input).string())
            .>append(">")
    end
    
    output
  
  fun print(string: String box) =>
    """
    Print a string (followed by a newline) to the STDOUT stream.
    This is for debugging purposes only, as it is not concurrency-safe.
    """
    _STDOUT.write_line(string)
  
  fun out(input: _Inspectable, input2: _Inspectable = None,
          input3: _Inspectable = None, input4: _Inspectable = None) =>
    """
    Print the inspect form of one or more objects to the STDOUT stream.
    This is for debugging purposes only, as it is not concurrency-safe.
    """
    if input4 isnt None then
      print(apply(input) + ", " + apply(input2) + ", " + apply(input3) + ", " + apply(input4))
    elseif input3 isnt None then
      print(apply(input) + ", " + apply(input2) + ", " + apply(input3))
    elseif input2 isnt None then
      print(apply(input) + ", " + apply(input2))
    else
      print(apply(input))
    end
