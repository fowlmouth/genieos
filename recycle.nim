import strutils, os

{.passL: "-framework AppKit".}
{.compile: "embed.m".}

proc macosxNimRecycle(filename: cstring): int {.importc, nodecl.}

proc recycle(filename: string) =
  let result = macosxNimRecycle(filename)
  if result != 0:
    OSError("error " & $result & " recycling " & filename)

proc test() =
  var filename : string

  for f in 0..999:
    filename = "onetest$1.todelete" % $f
    createDir filename
    recycle filename

when isMainModule:
  test()

