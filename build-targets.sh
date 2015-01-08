#!/bin/sh
# Script to build all of the targets needed by HBO

# ensure we run in this directory
cd "`dirname $0`"

# Only rebuild if we're at a different revision than what's been built already, unless 'force' is specified
BUILDREV=out/buildRev
if [ "$1" != "force" ] && [ -f $BUILDREV ] && [ "`cat $BUILDREV`" == "`git rev-parse HEAD`" ] ; then
    echo "V8 is up-to-date"
    exit 0
fi

if [ -z "$ANDROID_NDK_ROOT" ] ; then
    echo "Android NDK not configured; skipping"
    exit 0
fi

make clean || exit 1
# builddeps needs manual intervention to accept some certs
yes p | make builddeps || exit 1
make android_arm.release -j6 i18nsupport=off || exit 1

git rev-parse HEAD > .buildRev
