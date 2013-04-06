#import <AppKit/AppKit.h>

// Returns zero on success, non zero on failure.
int genieosMacosxNimRecycle(const char *filename)
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
