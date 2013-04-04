#include <stdlib.h>
#include <stdio.h>

#import <AppKit/AppKit.h>

void recycle(const char *filename)
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
	if (tag < 0 || ret == NO) {
		printf("Errors deleting %s\n", filename);
	} else {
		//printf("Yeah\n");
	}
}

int main(int argc, char **argv)
{
	char buf[100];
	int f;

	for (f = 0; f < 1000; f++) {
		sprintf(buf, "onetest%d.todelete", f);
		mkdir(buf, 0777);
	}
	for (f = 0; f < 1000; f++) {
		sprintf(buf, "onetest%d.todelete", f);
		recycle(buf);
	}

	return 0;
}
