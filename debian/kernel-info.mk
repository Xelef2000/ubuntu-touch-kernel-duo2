########################################################################
# Kernel settings
########################################################################

# Kernel variant. 
VARIANT = android

# Kernel base version
KERNEL_BASE_VERSION = 5.4.233

# The kernel cmdline to use
# UPDATED: Added stock console=ttyMSM0 and mandatory datapart= for Droidian rootfs on userdata.
KERNEL_BOOTIMAGE_CMDLINE = console=ttyMSM0,115200n8 log_buf_len=256K earlycon=msm_geni_serial,0x98c000 rcupdate.rcu_expedited=1 rcu_nocbs=0-7 kpti=off droidian.lvm.prefer datapart=/dev/block/bootdevice/by-name/userdata


# Slug for the device vendor.
DEVICE_VENDOR = microsoft

# Slug for the device model.
DEVICE_MODEL = lahaina

# Marketing-friendly full-name.
DEVICE_FULL_NAME = Surface Duo 2

# Whether to use configuration fragments to augment the kernel configuration.
KERNEL_CONFIG_USE_FRAGMENTS = 1

# Whether to use diffconfig to generate the device-specific configuration.
KERNEL_CONFIG_USE_DIFFCONFIG = 0

# Defconfig to use
KERNEL_DEFCONFIG = duo2_qgki_debug_defconfig

# Whether to include DTBs with the image. 
# UPDATED: Set to 0 for GKI/vendor_boot devices.
KERNEL_IMAGE_WITH_DTB = 0

# Path to the DTB
# KERNEL_IMAGE_DTB = arch/arm64/boot/dts/qcom/my_dtb.dtb

# Whether to include a DTB Overlay. 
# UPDATED: Set to 0 for GKI/vendor_boot devices.
KERNEL_IMAGE_WITH_DTB_OVERLAY = 0

# Path to the DTB overlay.
# KERNEL_IMAGE_DTB_OVERLAY = surface/duo2/surface-duo2-mp-overlay.dtbo

# Whether to include the DTB Overlay into the kernel image
# GKI devices should set this to 0
KERNEL_IMAGE_WITH_DTB_OVERLAY_IN_KERNEL = 0

# Various other settings that will be passed straight to mkbootimg
KERNEL_BOOTIMAGE_PAGE_SIZE = 4096
KERNEL_BOOTIMAGE_BASE_OFFSET = 0x00000000
KERNEL_BOOTIMAGE_KERNEL_OFFSET = 0x00008000
KERNEL_BOOTIMAGE_INITRAMFS_OFFSET = 0x01000000
KERNEL_BOOTIMAGE_SECONDIMAGE_OFFSET = 0x00f00000
KERNEL_BOOTIMAGE_TAGS_OFFSET = 0x00000100

# Specify boot image security patch level if needed
KERNEL_BOOTIMAGE_PATCH_LEVEL = 2024-10

# Specify boot image OS version if needed
KERNEL_BOOTIMAGE_OS_VERSION = 11.0.0

# Required for header version 2, ignore otherwise
# UPDATED: Set to the value found in the stock vendor_boot image header.
KERNEL_BOOTIMAGE_DTB_OFFSET = 0x01f00000

# Kernel bootimage version. 
# UPDATED: Set to 3 to match the extracted stock vendor_boot header version.
KERNEL_BOOTIMAGE_VERSION = 3

# Kernel initramfs compression. Defaults to gzip.
# lz4 is the standard compression for modern GKI devices.
KERNEL_INITRAMFS_COMPRESSION = lz4


# Whether to generate a vendor_boot image. 
# UPDATED: Set to 1 for GKI/vendor_boot devices.
KERNEL_BOOTIMAGE_GENERATE_VENDOR_BOOT = 1

# The cmdline for the vendor_boot image
KERNEL_BOOTIMAGE_VENDOR_CMDLINE = 

########################################################################
# Android verified boot
########################################################################

# Whether to build a flashable vbmeta.img. 
DEVICE_VBMETA_REQUIRED = 1

# Samsung devices require a special flag.
DEVICE_VBMETA_IS_SAMSUNG = 0

# boot partition size. 
KERNEL_BOOTIMAGE_PARTITION_SIZE = 100663296

########################################################################
# Automatic flashing on package upgrades
########################################################################

# Whether to enable kernel upgrades on package upgrades. Use 0 (no) or 1.
FLASH_ENABLED = 1

# If your device is treble-ized, but aonly, you should set the following to 1 (yes).
FLASH_IS_AONLY = 0

# Legacy device settings.
FLASH_IS_LEGACY_DEVICE = 0

# On some exynos devices partition names are capitalized.
FLASH_IS_EXYNOS = 0

# On some devices flashing userdata.img via fastboot fails.
FLASH_USE_TELNET = 0

# Device manufacturer.
FLASH_INFO_MANUFACTURER = Microsoft

# Device model.
FLASH_INFO_MODEL = Surface Duo 2

# Device CPU.
FLASH_INFO_CPU = Qualcomm

# Space-separated list of supported device ids as reported by fastboot
FLASH_INFO_DEVICE_IDS = model1 model2

########################################################################
# Kernel build settings
########################################################################

# Whether to cross-build. Use 0 (no) or 1.
BUILD_CROSS = 1

# (Cross-build only) The build triplet to use.
BUILD_TRIPLET = aarch64-linux-android-

# (Cross-build only) The build triplet to use with clang. 
BUILD_CLANG_TRIPLET = aarch64-linux-gnu-

# The compiler to use.
BUILD_CC = clang

# Use llvm instead of gcc.
BUILD_LLVM = 1

# Set to 1 to skip modules packaging if CONFIG_MODULES is disabled in defconfig 
BUILD_SKIP_MODULES = 0

# Set clang version
CLANG_VERSION = 6.0-4691093
# Set to 1 to use a manually installed toolchain
CLANG_CUSTOM = 0

# Extra paths to prepend to the PATH variable.
BUILD_PATH = /usr/lib/llvm-android-12.0-r416183b/bin

# Extra packages to add to the Build-Depends section.
DEB_TOOLCHAIN = clang-android-12.0-r416183b


# Where we're building on
DEB_BUILD_ON = amd64

# Where we're going to run this kernel on
DEB_BUILD_FOR = arm64

# Target kernel architecture
KERNEL_ARCH = arm64

# Kernel target to build
KERNEL_BUILD_TARGET = Image