## Tests genieos module procs.

import genieos, strutils, os

proc test_recycle() =
  var filename : string

  echo "Creating thousand directories to later recycle them."
  for f in 0..999:
    filename = "onetest$1.todelete" % $f
    createDir filename
    recycle filename

when isMainModule:
  test_recycle()
  echo "All tests done!"
