#!/bin/sh

CURRDIR=`pwd`
rm -Rf docs-*
for VERSION in develop `git tag -l`; do
	TMPDIR=/tmp/genieos-docs-$VERSION
	DESTDIR=docs-$VERSION
	rm -Rf $TMPDIR && rm -Rf $DESTDIR && mkdir -p $TMPDIR && \
		(git archive $VERSION | tar -xC $TMPDIR) && \
		cd $TMPDIR && \
		nimrod doc2 genieos.nim && \
		cd "${CURRDIR}" && \
		mkdir $DESTDIR && \
		cp $TMPDIR/genieos.html $DESTDIR && \
		git status && \
		echo "Finished updating docs"
done
