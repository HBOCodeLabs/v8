#!/bin/sh
# Script to build all of the targets needed by HBO

# ensure we run in this directory
cd "`dirname $0`"

if [ -z "$ANDROID_NDK_ROOT" ] ; then
    echo "ANDROID_NDK_ROOT variable not set" 2>&1
    exit 1
fi

ABI=${1:-armeabi-v7a}

case "$ABI" in
armeabi-v7a)
    V8TARGET=android_arm.release
    V8OPTS="arm7=true"
    ;;
arm)
    V8TARGET=android_arm.release
    V8OPTS="arm7=false"
    ;;
*)
    echo "Unknown/unsupported ABI $ABI" 1>&2
    exit 1
    ;;
esac

BUNDLE=out/hadron-v8-bundle/`git rev-parse --short HEAD`
mkdir -p $BUNDLE

cp -r include $BUNDLE

make builddeps || exit 1

make clean
echo "Outputting V8 build log to $BUILT/build.log"
make $V8TARGET i18nsupport=off -j 6 $V8OPTS || exit 1
mkdir $BUNDLE/$ABI/lib
cp out/$V8TARGET/*.a $BUNDLE/$ABI/lib
