#!/bin/bash

# Add Colors to unhappiness
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# AK Kernel Version
BASE_AK_VER="AK"
VER=".109.POSEIDON.FLO"
AK_VER=$BASE_AK_VER$VER

# AK Variables
export LOCALVERSION="~"`echo $AK_VER`
export CROSS_COMPILE=${HOME}/android/AK-linaro/4.9.1-2014.06.20140614.CR83/bin/arm-cortex_a15-linux-gnueabihf-
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=ak
export KBUILD_BUILD_HOST="kernel"

DATE_START=$(date +"%s")

echo
echo -e "${green}"
echo "AK Kernel Creation Script:"
echo "    _____                         "
echo "   (, /  |              /)   ,    "
echo "     /---| __   _   __ (/_     __ "
echo "  ) /    |_/ (_(_(_/ (_/(___(_(_(_"
echo " ( /                              "
echo " _/                               "
echo -e "${restore}"
echo

echo -e "${green}"
echo "------------------------"
echo "Show: AK Flo Settings"
echo "------------------------"
echo -e "${restore}"

MODULES_DIR=${HOME}/android/AK-anykernel-Flo/cwm/system/lib/modules
KERNEL_DIR=`pwd`
OUTPUT_DIR=${HOME}/android/AK-anykernel-Flo/zip
CWM_DIR=${HOME}/android/AK-anykernel-Flo/cwm
ZIMAGE_DIR=${HOME}/android/AK-xGenesis-Flo/arch/arm/boot
CWM_MOVE=${HOME}/android/AK-releases
ZIMAGE_ANYKERNEL=${HOME}/android/AK-anykernel-Flo/cwm/kernel
ANYKERNEL_DIR=${HOME}/android/AK-anykernel-Flo
KCONTROL_GPU=${HOME}/android/kcontrol_gpu_msm

echo -e "${red}"; echo "COMPILING VERSION:"; echo -e "${blink_red}"; echo "$LOCALVERSION"; echo -e "${restore}"
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH
echo "MODULES_DIR="$MODULES_DIR
echo "KERNEL_DIR="$KERNEL_DIR
echo "OUTPUT_DIR="$OUTPUT_DIR
echo "CWM_DIR="$CWM_DIR
echo "ZIMAGE_DIR="$ZIMAGE_DIR
echo "CWM_MOVE="$CWM_MOVE
echo "ZIMAGE_ANYKERNEL="$ZIMAGE_ANYKERNEL
echo "ANYKERNEL_DIR="$ANYKERNEL_DIR
echo "KCONTROL_GPU="$KCONTROL_GPU

echo -e "${green}"
echo "-------------------------"
echo "Making: AK Flo Defconfig"
echo "-------------------------"
echo -e "${restore}"

make "ak_flo_defconfig"
make -j9

echo -e "${green}"
echo "--------------------------"
echo "Copy: Modules to direcroty"
echo "--------------------------"
echo -e "${restore}"

rm `echo $MODULES_DIR"/*"`
find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;
echo

echo -e "${green}"
echo "----------------------------"
echo "Create: Zip and moving files"
echo "----------------------------"
echo -e "${restore}"
cp -vr $ZIMAGE_DIR/zImage $ZIMAGE_ANYKERNEL
echo

cd $CWM_DIR
zip -r `echo $AK_VER`.zip *
mv  `echo $AK_VER`.zip $OUTPUT_DIR

echo -e "${green}"
echo "-------------------------"
echo "The End: AK is Born"
echo "-------------------------"
echo -e "${restore}"

cp -vr $OUTPUT_DIR/`echo $AK_VER`.zip $CWM_MOVE
echo

cd $ANYKERNEL_DIR
git reset --hard
echo

cd $KERNEL_DIR

echo -e "${green}"
echo "-------------------------"
echo "Build Completed in:"
echo "-------------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
