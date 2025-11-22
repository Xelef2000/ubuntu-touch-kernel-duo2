########################################################################
# Device Configuration for Surface Duo 2 (lahaina)
# Droidian Port - Header v3
########################################################################

# ---------------------------------------------------
# 1. Device & Vendor Information
# ---------------------------------------------------
DEVICE_VENDOR = microsoft
DEVICE_MODEL = lahaina
DEVICE_FULL_NAME = Surface Duo 2

# ---------------------------------------------------
# 2. Kernel Build Settings
# ---------------------------------------------------
VARIANT = android
KERNEL_BASE_VERSION = 5.4.233
KERNEL_ARCH = arm64
KERNEL_BUILD_TARGET = Image

# Compiler Settings
BUILD_CROSS = 1
BUILD_TRIPLET = aarch64-linux-android-
BUILD_CLANG_TRIPLET = aarch64-linux-gnu-
BUILD_CC = clang
BUILD_LLVM = 1
CLANG_VERSION = 6.0-4691093
CLANG_CUSTOM = 0
BUILD_PATH = /usr/lib/llvm-android-12.0-r416183b/bin
DEB_TOOLCHAIN = clang-android-12.0-r416183b

# Configuration
KERNEL_DEFCONFIG = duo2_qgki_debug_defconfig
KERNEL_CONFIG_USE_FRAGMENTS = 1
KERNEL_CONFIG_USE_DIFFCONFIG = 0
BUILD_SKIP_MODULES = 0

# Kernel Command Line
# Note: 'datapart' is mandatory for Droidian to find the rootfs
KERNEL_BOOTIMAGE_CMDLINE = console=ttyMSM0,115200n8 log_buf_len=256K earlycon=msm_geni_serial,0x98c000 rcupdate.rcu_expedited=1 rcu_nocbs=0-7 kpti=off droidian.lvm.prefer datapart=/dev/block/bootdevice/by-name/userdata

# ---------------------------------------------------
# 3. DTB (Device Tree Blob) Settings
# ---------------------------------------------------
# For Header v3, DTB is NOT appended to kernel (Image.gz-dtb), 
# it is passed as a standalone file to vendor_boot.

KERNEL_IMAGE_WITH_DTB = 1
KERNEL_IMAGE_WITH_DTB_OVERLAY = 0
KERNEL_IMAGE_WITH_DTB_OVERLAY_IN_KERNEL = 0

# --- ACTIVE DTB SELECTION ---
# Using the Source-built DTB 
# KERNEL_BOOTIMAGE_DTB = /buildd/sources/out/KERNEL_OBJ/arch/arm64/boot/dts/vendor/qcom/lahaina-v2.1.dtb
# KERNEL_IMAGE_DTB = arch/arm64/boot/dts/vendor/qcom/lahaina-v2.1.dtb
# KERNEL_BOOTIMAGE_DTB = device/microsoft/surface-duo2/prebuilts/stock_duo2.dtb
# KERNEL_IMAGE_DTB = device/microsoft/surface-duo2/prebuilts/stock_duo2.dtb

KERNEL_BOOTIMAGE_DTB = device/microsoft/surface-duo2/prebuilts/stock_duo2.dtb
# KERNEL_DTB = vendor/qcom/lahaina-v2.1.dtb

# --- PREBUILT REFERENCES ---
# If using prebuilt, ensure this file exists in your device tree:
# KERNEL_BOOTIMAGE_DTB = device/microsoft/surface-duo2/prebuilts/stock_duo2.dtb
# KERNEL_IMAGE_DTB = device/microsoft/surface-duo2/prebuilts/stock_duo2.dtb

# ---------------------------------------------------
# 4. Boot Image & Vendor Boot Settings (Header v3)
# ---------------------------------------------------
KERNEL_BOOTIMAGE_HEADER_VERSION = 3
KERNEL_BOOTIMAGE_VERSION = 3
KERNEL_BOOTIMAGE_PAGE_SIZE = 4096

# Offsets
KERNEL_BOOTIMAGE_BASE_OFFSET = 0x00000000
KERNEL_BOOTIMAGE_KERNEL_OFFSET = 0x00008000
KERNEL_BOOTIMAGE_INITRAMFS_OFFSET = 0x01000000
KERNEL_BOOTIMAGE_SECONDIMAGE_OFFSET = 0x00f00000
KERNEL_BOOTIMAGE_TAGS_OFFSET = 0x00000100
KERNEL_BOOTIMAGE_DTB_OFFSET = 0x01f00000

# Metadata
KERNEL_BOOTIMAGE_PATCH_LEVEL = 2024-10
KERNEL_BOOTIMAGE_OS_VERSION = 11.0.0
KERNEL_BOOTIMAGE_PARTITION_SIZE = 100663296

# --- VENDOR BOOT CONFIGURATION ---
KERNEL_BOOTIMAGE_GENERATE_VENDOR_BOOT = 1
KERNEL_BOOTIMAGE_VENDOR_CMDLINE = 

# This points to the stock vendor ramdisk (fstab, modules, QCOM binaries).
KERNEL_BOOTIMAGE_VENDOR_RAMDISK = device/microsoft/surface-duo2/prebuilts/vendor_ramdisk.cpio.gz

# Ramdisk Compression
KERNEL_INITRAMFS_COMPRESSION = lz4
TARGET_RAMDISK_FORMAT = lz4

# ---------------------------------------------------
# 5. Flashing & AVB Settings
# ---------------------------------------------------
DEVICE_VBMETA_REQUIRED = 1
DEVICE_VBMETA_IS_SAMSUNG = 0

FLASH_ENABLED = 1
FLASH_INFO_MANUFACTURER = Microsoft
FLASH_INFO_MODEL = Surface Duo 2
FLASH_INFO_CPU = Qualcomm
FLASH_INFO_DEVICE_IDS = model1 model2
FLASH_IS_AONLY = 0
FLASH_IS_LEGACY_DEVICE = 0
FLASH_IS_EXYNOS = 0
FLASH_USE_TELNET = 0

# ---------------------------------------------------
# 6. Build System Meta
# ---------------------------------------------------
DEB_BUILD_ON = amd64
DEB_BUILD_FOR = arm64