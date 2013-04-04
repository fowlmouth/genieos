import strutils, os

{.passL: "-framework AppKit".}
{.emit: """
#import <AppKit/AppKit.h>

// Returns zero on success, non zero on failure.
int _macosxNimRecycle(const char *filename)
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSString *path = [[NSString alloc] initWithUTF8String:filename];
  NSString *folder = [path stringByDeletingLastPathComponent];
  NSArray *files = [NSArray arrayWithObject:[path lastPathComponent]];

  NSInteger tag = 0;
  const BOOL ret = [[NSWorkspace sharedWorkspace]
    performFileOperation:NSWorkspaceRecycleOperation
    source:folder destination:nil files:files tag:&tag];
  [pool release];

  if (tag < 0)
    return tag;
  else if (ret == NO)
   return 1;
  else
    return 0;
}
""".}

proc macosxNimRecycle(filename: cstring): int {.
  importc: "_macosxNimRecycle", nodecl.}

proc recycle(filename: string) =
  let result = macosxNimRecycle(filename)
  if result != 0:
    raise newException(EOS, "error " & $result & " recycling " & filename)

proc test() =
  var filename : string

  for f in 0..999:
    filename = "onetest$1.todelete" % $f
    createDir filename
    recycle filename

when isMainModule:
  test()

