#!/bin/sh
# Script to build all of the targets needed by HBO

# ensure we run in this directory
cd "`dirname $0`"

ABILIST="$@"
if [ -z "$ABILIST" ] ; then
    ABILIST="armeabi-v7a x86"
fi

gclient sync --nohooks

BUNDLE=out/hadron-v8-bundle/`git rev-parse --short HEAD`
mkdir -p $BUNDLE

doxygen
cp -r doc $BUNDLE

cp -r include $BUNDLE

for ABI in $ABILIST ; do
    case "$ABI" in
    armeabi-v7a)
        V8TARGET=android_arm.release
        V8OPTS="arm7=true"
        ;;
    arm)
        V8TARGET=android_arm.release
        V8OPTS="arm7=false"
        ;;
    arm64)
        V8TARGET=android_arm64.release
        ;;
    x86)
        V8TARGET=android_ia32.release
        ;;
    *)
        echo "Unknown/unsupported ABI $ABI" 1>&2
        exit 1
        ;;
    esac

    make clean
    make $V8TARGET i18nsupport=off -j 3 $V8OPTS component=static_library || exit 1
    mkdir -p $BUNDLE/$ABI/lib
    cp out/$V8TARGET/*.a $BUNDLE/$ABI/lib
done

(cd out ; tar czvf hadron-v8-bundle.tar.gz hadron-v8-bundle )
