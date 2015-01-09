#!/bin/sh
# Script to build all of the targets needed by HBO

# ensure we run in this directory
cd "`dirname $0`"

if [ -z "$ANDROID_NDK_ROOT" ] ; then
    echo "ANDROID_NDK_ROOT variable not set" 2>&1
    exit 1
fi

ABILIST="$@"
if [ -z "$ABILIST" ] ; then
    ABILIST="armeabi-v7a"
fi

BUNDLE=out/hadron-v8-bundle/`git rev-parse --short HEAD`
mkdir -p $BUNDLE

cp -r include $BUNDLE

make builddeps || exit 1

for ABI in $ABILIST ; do
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

    make clean
    make $V8TARGET i18nsupport=off -j 6 $V8OPTS || exit 1
    mkdir -p $BUNDLE/$ABI/lib
    cp out/$V8TARGET/*.a $BUNDLE/$ABI/lib
done

(cd out ; tar czvf hadron-v8-bundle.tar.gz hadron-v8-bundle )
