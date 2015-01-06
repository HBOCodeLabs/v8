#!/bin/sh
# Script to build all of the targets needed by HBO

make clean
make builddeps
make android_arm.release -j8 i18nsupport=off
