#import <AppKit/AppKit.h>

// Returns zero on success, non zero on failure.
int genieosMacosxNimRecycle(const char *filename)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *path = [[NSString alloc] initWithUTF8String:filename];
	NSString *folder = [path stringByDeletingLastPathComponent];
	NSArray *files = [NSArray arrayWithObject:[path lastPathComponent]];
	[path release];

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

// Plays a standard error beep, the sound won't be heard if the process exits.
void genieosMacosxBeep()
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSBeep(); // Seems to take 150ms to play fully.
	[pool release];
}

// Returns -1 on failure, or length of the sound which started to play.
double genieosMacosxPlayAif(const char *filename)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *path = [[NSString alloc] initWithUTF8String:filename];
	NSSound *sound = [[NSSound alloc]
		initWithContentsOfFile:path byReference:YES];
	[path release];

	if (!sound) {
		[pool release];
		return -1;
	}

	const double ret = [sound duration];
	[sound play];
	[sound autorelease];
	[pool release];
	return ret;
}
