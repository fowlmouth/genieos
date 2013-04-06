## Too awesome procs to be included in nimrod.os module.
##
## This module contains several procs which are too awesome to be included in
## nimrod's os module. Procs may not be available for your platform, please
## check their availability at compile time with `when`. Example checking for
## the availability of the recycle proc:
##
## .. nimrod-code:
##
## when not defined(genieos.recycle):
##   proc recycle(filename: string):
##     if existsDir filename:
##       removeDir filename
##     else:
##       removeFile filename

import os

proc recycle*(filename: string)
  ## Moves a file or directory to the recycle bin of the user.

when defined(macosx):
  {.passL: "-framework AppKit".}
  {.compile: "private/genieos_macosx_recycle.m".}
  proc genieosMacosxNimRecycle(filename: cstring): int {.importc, nodecl.}

  proc recycle*(filename: string) =
    let result = genieosMacosxNimRecycle(filename)
    if result != 0:
      OSError("error " & $result & " recycling " & filename)
