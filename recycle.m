#include <stdlib.h>

#import <Foundation/Foundation.h>
#include <CoreServices/CoreServices.h>

void recycle(const char *filename)
{
	NSString* path = [[NSString alloc] initWithUTF8String:filename];
	OSStatus status = 0;

	FSRef ref;
	status = FSPathMakeRefWithOptions(
		(const UInt8 *)[path fileSystemRepresentation], 
		kFSPathMakeRefDoNotFollowLeafSymlink,
		&ref, 
		NULL
	);  
	[path release];
	if (0 == status) {
		printf("failed to make FSRef\n");
		return;
	}

	status = FSMoveObjectToTrashSync(&ref, NULL, kFSFileOperationSkipPreflight);
	printf("status: %i\n", (int)status);
}

int main(int argc, char **argv)
{
	int f;
	for (f = 1; argv[f]; f++) {
		printf("%s\n", argv[f]);
		recycle(argv[f]);
	}

	return 0;
}
