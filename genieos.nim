## Too awesome procs to be included in nimrod.os module.
##
## This module contains several procs which are *too awesome* to be included in
## `Nimrod's <http://nimrod-code.org>`_ `os module
## <http://nimrod-code.org/os.html>`_. Procs may not be available for your
## platform, please check their availability at compile time with ``when``.
## Example checking for the availability of the ``recycle`` proc:
##
## .. code-block:: Nimrod
##   when not defined(genieos.recycle):
##     proc recycle(filename: string):
##       if existsDir filename:
##         removeDir filename
##       else:
##         removeFile filename
##
## Source code for this module can be found at
## https://github.com/gradha/genieos.

import os

type
  TSound* = enum
    defaultBeep, recycleBin

const
  VERSION_STR* = "9.1.2" ## Module version as a string.
  VERSION_INT* = (major: 9, minor: 1, maintenance: 2) ## \
  ## Module version as an integer tuple.
  ##
  ## Major versions changes mean a break in API backwards compatibility, either
  ## through removal of symbols or modification of their purpose.
  ##
  ## Minor version changes can add procs (and maybe default parameters). Minor
  ## odd versions are development/git/unstable versions. Minor even versions
  ## are public stable releases.
  ##
  ## Maintenance version changes mean I'm not perfect yet despite all the kpop
  ## I watch.

proc recycle*(filename: string)
  ## Moves a file or directory to the recycle bin of the user.
  ##
  ## If there are any errors recycling the file EOS will be raised. Note that
  ## unlike os.removeFile() and os.removeDir() this works for any kind of file
  ## type.
  ##
  ## At the moment this is only implemented under macosx.

proc playSound*(soundType = defaultBeep): float64 {.discardable.}
  ## Tries to play a sound provided by your OS.
  ##
  ## May stop playing if your process exits in the meantime. For this reason
  ## the proc returns the amount of seconds you have to wait for the sound to
  ## fully play out in case you want to wait for it.
  ##
  ## Returns a negative value if for some reason the sound could not be loaded
  ## or played back to the user. In most cases this would mean your OS is not
  ## supported because sounds typically have a hardcoded path which may change
  ## on newer versions. Just in case file a bug report.
  ##
  ## At the moment this is only implemented under macosx.

when defined(macosx):
  {.passL: "-framework AppKit".}
  {.compile: "private/genieos_macosx.m".}
  proc genieosMacosxNimRecycle(filename: cstring): int {.importc, nodecl.}

  proc genieosMacosxBeep() {.importc, nodecl.}

  proc genieosMacosxPlayAif(filename: cstring): cdouble {.importc.}

  proc playSound*(soundType = defaultBeep): float64 =
    case soundType
    of defaultBeep:
      genieosMacosxBeep()
      result = 0.150
      return
    of recycleBin:
      # Path to recycle sounds from http://stackoverflow.com/a/9159760/172690
      let
        f1 = "/System/Library/Components/CoreAudio.component/" &
          "Contents/SharedSupport/SystemSounds/dock/drag to trash.aif"
        f2 = "/System/Library/Components/CoreAudio.component/" &
          "Contents/Resources/SystemSounds/drag to trash.aif"
      if existsFile(f1):
        result = genieosMacosxPlayAif(f1)
      elif existsFile(f2):
        result = genieosMacosxPlayAif(f2)
      else:
        result = -1

  proc recycle*(filename: string) =
    let result = genieosMacosxNimRecycle(filename)
    if result != 0:
      OSError("error " & $result & " recycling " & filename)
