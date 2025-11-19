########################################################################
# Kernel settings
########################################################################

VARIANT = android
KERNEL_BASE_VERSION = 5.4.233
KERNEL_BOOTIMAGE_CMDLINE = console=tty0 log_buf_len=256K earlycon=msm_geni_serial,0x98c000 rcupdate.rcu_expedited=1 rcu_nocbs=0-7 kpti=off droidian.lvm.prefer
DEVICE_VENDOR = microsoft
DEVICE_MODEL = lahaina
DEVICE_FULL_NAME = Surface Duo 2
KERNEL_CONFIG_USE_FRAGMENTS = 1
KERNEL_CONFIG_EXTRA_FRAGMENTS = halium.config
KERNEL_CONFIG_USE_DIFFCONFIG = 0
KERNEL_DEFCONFIG = duo2_qgki_debug_defconfig
KERNEL_IMAGE_WITH_DTB = 0  # Changed to 0 as per earlier fix
KERNEL_IMAGE_WITH_DTB_OVERLAY = 1
KERNEL_IMAGE_WITH_DTB_OVERLAY_IN_KERNEL = 0
KERNEL_BOOTIMAGE_PAGE_SIZE = 4096
KERNEL_BOOTIMAGE_BASE_OFFSET = 0x00000000
KERNEL_BOOTIMAGE_KERNEL_OFFSET = 0x00008000
KERNEL_BOOTIMAGE_INITRAMFS_OFFSET = 0x01000000
KERNEL_BOOTIMAGE_SECONDIMAGE_OFFSET = 0x00f00000
KERNEL_BOOTIMAGE_TAGS_OFFSET = 0x00000100
KERNEL_BOOTIMAGE_PATCH_LEVEL = 2024-10
KERNEL_BOOTIMAGE_OS_VERSION = 11.0.0
KERNEL_BOOTIMAGE_DTB_OFFSET = 0x01f00000
KERNEL_BOOTIMAGE_VERSION = 4
KERNEL_INITRAMFS_COMPRESSION = lz4
KERNEL_BOOTIMAGE_GENERATE_VENDOR_BOOT = 0
KERNEL_BOOTIMAGE_VENDOR_CMDLINE =

########################################################################
# Android verified boot
########################################################################

DEVICE_VBMETA_REQUIRED = 1
DEVICE_VBMETA_IS_SAMSUNG = 0
KERNEL_BOOTIMAGE_PARTITION_SIZE = 100663296

########################################################################
# Automatic flashing on package upgrades
########################################################################

FLASH_ENABLED = 1
FLASH_IS_AONLY = 0
FLASH_IS_LEGACY_DEVICE = 0
FLASH_IS_EXYNOS = 0
FLASH_USE_TELNET = 0
FLASH_INFO_MANUFACTURER = Microsoft
FLASH_INFO_MODEL = Surface Duo 2
FLASH_INFO_CPU = Qualcomm
FLASH_INFO_DEVICE_IDS = model1 model2

########################################################################
# Kernel build settings
########################################################################

BUILD_CROSS = 1
BUILD_TRIPLET = aarch64-linux-android-
BUILD_CLANG_TRIPLET = aarch64-linux-gnu-
BUILD_CC = clang
BUILD_LLVM = 1
BUILD_SKIP_MODULES = 0
CLANG_VERSION = 6.0-4691093
CLANG_CUSTOM = 0
BUILD_PATH = /usr/lib/llvm-android-12.0-r416183b/bin
# Corrected DEB_TOOLCHAIN to include the required initramfs package:
DEB_TOOLCHAIN = linux-initramfs-halium-generic:arm64, binutils-aarch64-linux-gnu, clang-android-12.0-r416183b
DEB_BUILD_ON = amd64
DEB_BUILD_FOR = arm64
KERNEL_ARCH = arm64
KERNEL_BUILD_TARGET = Image
