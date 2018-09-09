#!/bin/bash

echo "Hey, inside script"

USERCMD="/home/ajinath/usercmd/cmd"
RIMOCMD="/home/ajinath/0001-old-home/ajinath/usercmd/cmd/projRimoFlasher"
USERCMD="${USERCMD}:/home/ajinath/0001-old-home/ajinath/work/gdb-debugger/Crash-utility/crash-7.1.9"
NDK="/home/ajinath/0001-old-home/ajinath/work/tools/android-ndk-r13/prebuilt/linux-x86_64/bin"
ANDROID_SDK_TOOL="/home/ajinath/0001-old-home/ajinath/android-sdk-linux/platform-tools"
ANDROID_SDK_TOOL1="/home/ajinath/0001-old-home/ajinath/android-sdk-linux/tools"
ANDROID_SDK_TOOL_BUILD_TOOL="/home/ajinath/0001-old-home/ajinath/android-sdk-linux/build-tools/25.0.1"

export PATH=$PATH:$USERCMD:$ANDROID_SDK_TOOL:$RIMOCMD:$ANDROID_SDK_TOOL_BUILD_TOOL:$ANDROID_SDK_TOOL1:$NDK
export TERM="xterm-256color"

source build/envsetup.sh
echo "source command done"
#ndk-stack  -sym $1 -dump logcat.txt

crash-from-log.sh $1 $2
