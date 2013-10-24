## Tests genieos module procs.

import genieos, strutils, os

proc test_recycle() =
  var filename : string

  echo "Creating thousand directories to later recycle them."
  for f in 0..999:
    filename = "onetest$1.todelete" % $f
    createDir filename
    recycle filename

proc test_clipboard() =
  let text = get_clipboard_string()
  echo "Clipboard content ", if text.isNil: "(nil)" else: $text


when isMainModule:
  test_clipboard()
  test_recycle()
  echo "All tests done!"
