########################################################################
# Kernel settings - Samsung Galaxy Note10 Lite (SM-N770F, r7)
# Exynos 9810 | Android 13 stock | boot header v2
# Every boot parameter below was verified by unpacking the stock boot.img
# with unpack_bootimg.
########################################################################

# Android ("downstream") kernel
VARIANT = android

# Kernel base version (kernel Makefile: VERSION=4 PATCHLEVEL=9 SUBLEVEL=191)
KERNEL_BASE_VERSION = 4.9.191

# Stock cmdline plus the console=tty0 and droidian.lvm.prefer entries Droidian
# needs. Note: no 'systempart' entry - the porting guide requires it removed.
KERNEL_BOOTIMAGE_CMDLINE = androidboot.selinux=permissive loop.max_part=7 console=tty0 droidian.lvm.prefer

DEVICE_VENDOR = samsung
DEVICE_MODEL = r7
DEVICE_PLATFORM = exynos9810
DEVICE_FULL_NAME = Samsung Galaxy Note10 Lite

# Our own Halium/Droidian-compatible defconfig is already complete; no
# fragments needed.
KERNEL_CONFIG_USE_FRAGMENTS = 0
KERNEL_CONFIG_USE_DIFFCONFIG = 0
KERNEL_DEFCONFIG = exynos9810-r7_halium_defconfig

# DTB: the Samsung bootloader expects a DT TABLE (magic d7b7ab1e) in the
# boot.img dtb area, not a raw DTB (d00dfeed). Handing it a raw DTB gives:
#     Odin mode (DT Load Fail) / [DTH] dt table header check failed
# Fix: KERNEL_PREBUILT_DT from the porting guide ("available for devices with
# a prebuilt DT image (such as samsungs)"). We use the known-good DT table
# extracted from the stock boot.img.
KERNEL_IMAGE_WITH_DTB = 1
# debian/rules copies this file into $(KERNEL_OUT)/ (prebuilt-dt-prepare)
KERNEL_IMAGE_DTB = samsung-dt-table.img

# DTBO: six revision overlays exist for r7 (exynos9810-r7_eur_open_00..05.dtbo).
# The stock DTBO partition is left in place, so nothing is embedded into the
# kernel image.
KERNEL_IMAGE_WITH_DTB_OVERLAY = 1
KERNEL_IMAGE_WITH_DTB_OVERLAY_IN_KERNEL = 0

# mkbootimg offsets - VERIFIED against the stock boot.img
KERNEL_BOOTIMAGE_PAGE_SIZE = 2048
KERNEL_BOOTIMAGE_BASE_OFFSET = 0x10000000
KERNEL_BOOTIMAGE_KERNEL_OFFSET = 0x00008000
KERNEL_BOOTIMAGE_INITRAMFS_OFFSET = 0x01000000
KERNEL_BOOTIMAGE_SECONDIMAGE_OFFSET = 0x00000000
KERNEL_BOOTIMAGE_TAGS_OFFSET = 0x00000100

# Required for header v2. Stock boot.img: dtb address 0x10000000,
# base 0x10000000 -> offset 0.
KERNEL_BOOTIMAGE_DTB_OFFSET = 0x00000000

# Stock boot.img: os version 13.0.0, patch level 2024-02
KERNEL_BOOTIMAGE_OS_VERSION = 13.0.0
KERNEL_BOOTIMAGE_PATCH_LEVEL = 2024-02

# Device shipped with Android 10, and the stock boot.img confirms it:
# header version 2
KERNEL_BOOTIMAGE_VERSION = 2

# Non-GKI device -> gzip initramfs
KERNEL_INITRAMFS_COMPRESSION = gz

# vendor_boot only exists for header v3+
KERNEL_BOOTIMAGE_GENERATE_VENDOR_BOOT = 0
KERNEL_BOOTIMAGE_VENDOR_CMDLINE =

########################################################################
# Android verified boot
########################################################################

DEVICE_VBMETA_REQUIRED = 1

# REQUIRED: flag 0 for Samsung devices
DEVICE_VBMETA_IS_SAMSUNG = 1

# From the PIT dump: BOOT partition size is 57,671,680 bytes
KERNEL_BOOTIMAGE_PARTITION_SIZE = 57671680

########################################################################
# Automatic flashing (on package upgrades)
########################################################################

FLASH_ENABLED = 1

# Not an A/B device (the PIT has a single BOOT/RECOVERY, no _a/_b slots)
FLASH_IS_AONLY = 0
FLASH_IS_LEGACY_DEVICE = 1

# Partition names in the PIT dump are UPPERCASE (BOOT, RECOVERY, DTBO)
# -> Exynos mode
FLASH_IS_EXYNOS = 1

# Samsung has no fastboot; userdata is written over heimdall/telnet
FLASH_USE_TELNET = 1

FLASH_INFO_MANUFACTURER = samsung
FLASH_INFO_MODEL = SM-N770F
FLASH_INFO_CPU = Samsung
FLASH_INFO_DEVICE_IDS = r7 r7naxx

########################################################################
# Kernel build settings
########################################################################

BUILD_CROSS = 1
BUILD_TRIPLET = $(CURDIR)/debian/binbridge/aarch64-linux-android-
BUILD_CLANG_TRIPLET = aarch64-linux-gnu-
# clang python2-wrapper workaround:
# In the AOSP clang packages bin/clang is a PYTHON 2 wrapper
# (#!/usr/bin/env python -> clang.real). The build container has no python2:
#     env: 'python': No such file or directory
# With the compiler unable to run at all, EVERY cc-option probe fails and the
# kernel emits the false negative
#     "Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: ... not supported"
# (The clang-14 package ships a real binary as bin/clang, so this is only
# visible with clang-9.)
# Fix: point at the real binary by absolute path.
BUILD_CC = $(BUILD_PATH)/clang-9

# 4.9 kernel; llvm=1 (full LLVM toolchain) is for android12+
BUILD_LLVM = 0
BUILD_SKIP_MODULES = 0

# TOOLCHAIN CHOICE - the one verified to work on the device:
# The kernel we hand-built and confirmed BOOTING was compiled with
# AOSP clang r349610 (clang 8.0.8). A kernel built with Droidian's suggested
# 14.0-r450784d HANGS at the boot logo (never proceeds), while the clang-8
# build runs. The closest version available in the package list is
# 9.0-r353983c (same Android 10 era, adjacent to r349610).
#
# The snippet installs the package as "clang-android-$(CLANG_VERSION)", so
# do NOT prefix this value with "android-".
CLANG_VERSION = 9.0-r353983c
CLANG_CUSTOM = 0
BUILD_PATH = /usr/lib/llvm-android-$(CLANG_VERSION)/bin

DEB_TOOLCHAIN = linux-initramfs-halium-generic:arm64, binutils-aarch64-linux-gnu, gcc-4.9-aarch64-linux-android, g++-4.9-aarch64-linux-android, libgcc-4.9-dev-aarch64-linux-android-cross

DEB_BUILD_ON = amd64
DEB_BUILD_FOR = arm64
KERNEL_ARCH = arm64

# This kernel produces 'Image' (not Image.gz)
KERNEL_BUILD_TARGET = Image
