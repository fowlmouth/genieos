#!/bin/sh

CURRDIR=`pwd`
TMPDIR=/tmp/genieos-docs
rm -Rf $TMPDIR && mkdir $TMPDIR && \
	(git archive master | tar -xC $TMPDIR) && \
	cd $TMPDIR && \
	nimrod doc2 genieos.nim && \
	cd "${CURRDIR}" &&
	cp $TMPDIR/genieos.html . && \
	git status && \
	echo "Finished updating docs"
