#!/bin/bash
set -e

echo "=================================================="
echo "Surface Duo 2 Single-Repo Kernel Build Script"
echo "=================================================="

# --- 1. Argument Parsing ---
if [[ "$1" == "-c" && -n "$2" ]]; then
    KERNCONFIG_NAME="$2"
else
    echo "Usage: $0 -c <config_name>"
    echo "Example: $0 -c duo2_gki_defconfig"
    exit 1
fi

# DEFCONFIG should just be the *name* of the config file.
# The kernel Makefile automatically looks in arch/arm64/configs/
export DEFCONFIG="${KERNCONFIG_NAME}"
CONFIG_FILE_PATH="arch/arm64/configs/${KERNCONFIG_NAME}"

if [ ! -f "${CONFIG_FILE_PATH}" ]; then
    echo "Error: Config file not found at ${CONFIG_FILE_PATH}"
    exit 1
fi

echo "Using config name: ${DEFCONFIG}"
echo "Found config file at: ${CONFIG_FILE_PATH}"

# --- 2. Environment Setup (Merged from kernel-build.sh) ---
export ROOT_DIR=$(pwd)
export BUILD_PATH=${ROOT_DIR} # Assumes prebuilts/ and device_build/ are at the root
export KERNEL_DIR=.           # Kernel source is at the root

# Check for required directories and files
if [ ! -d "${BUILD_PATH}/prebuilts" ]; then
    echo "Error: 'prebuilts' directory not found at root."
    echo "Please copy it from your original source checkout."
    exit 1
fi
if [ ! -f "${BUILD_PATH}/device_build/kernel/kernel.json" ]; then
    echo "Error: 'device_build/kernel/kernel.json' not found."
    echo "Please copy the 'device_build' directory from your original source."
    exit 1
fi
if [ ! -f "${BUILD_PATH}/device_build/modules.blocklist.lahaina" ]; then
    echo "Warning: 'device_build/modules.blocklist.lahaina' not found."
    echo "You may need to copy this from 'device/qcom/kernelscripts/modules_blocklist/'."
fi

# Standard Paths
export OUT_DIR=${ROOT_DIR}/out/target/product/duo2/obj/kernel/msm-5.4
export KERNEL_MODULES_OUT=${ROOT_DIR}/out/target/product/duo2/dlkm/lib/modules
export KERNEL_HEADERS_INSTALL=${OUT_DIR}/usr
export MODULES_STAGING_DIR=${ROOT_DIR}/out/staging
export UNSTRIPPED_DIR=${KERNEL_MODULES_OUT}/unstripped
export DIST_DIR=${ROOT_DIR}/out/dist

# Toolchain
export MAKE_PATH=${BUILD_PATH}/prebuilts/build-tools/linux-x86/bin/
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=${BUILD_PATH}/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CLANG_TRIPLE=aarch64-linux-gnu-

export REAL_CC="${BUILD_PATH}/prebuilts/clang/host/linux-x86/clang-r416183b/bin/clang"
export CC_ARG="CC=${REAL_CC}"
export LD=${BUILD_PATH}/prebuilts/clang/host/linux-x86/clang-r416183b/bin/ld.lld
export HOSTCC=${BUILD_PATH}/prebuilts/clang/host/linux-x86/clang-r416183b/bin/clang
export HOSTAR=${BUILD_PATH}/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/bin/x86_664-linux-ar
export HOSTLD=${BUILD_PATH}/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/bin/x86_64-linux-ld

# Includes
export TARGET_INCLUDES="-I${KERNEL_DIR}/include/uapi -I/usr/include -I/usr/include/x86_64-linux-gnu -I${KERNEL_DIR}/include -L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld"
export TARGET_LINCLUDES="-L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld"

# Make Arguments
export TARGET_KERNEL_MAKE_ENV="
REAL_CC=$REAL_CC \
CLANG_TRIPLE=$CLANG_TRIPLE \
AR=${BUILD_PATH}/prebuilts/clang/host/linux-x86/clang-r416183b/bin/llvm-ar \
LLVM_NM=${BUILD_PATH}/prebuilts/clang/host/linux-x86/clang-r416183b/bin/llvm-nm \
LD=$LD \
NM=${BUILD_PATH}/prebuilts/clang/host/linux-x86/clang-r416183b/bin/llvm-nm \
CONFIG_BUILD_ARM64_DT_OVERLAY=y \
HOSTCC=$HOSTCC \
HOSTAR=$HOSTAR \
HOSTLD=$HOSTLD \
"
export MAKE_ARGS=$TARGET_KERNEL_MAKE_ENV

# Module Packaging
export VENDOR_KERNEL_MODULES_ARCHIVE=vendor_modules.zip
export VENDOR_RAMDISK_KERNEL_MODULES_ARCHIVE=vendor_ramdisk_modules.zip
export TARGET_PRODUCT=lahaina # From original script

# Get VENDOR_RAMDISK_KERNEL_MODULES from kernel.json
case "$KERNCONFIG_NAME" in
    "duo2_qgki_debug_defconfig")
    export VENDOR_RAMDISK_KERNEL_MODULES=$(cat ${BUILD_PATH}/device_build/kernel/kernel.json | jq -r '."lahaina-qgki-debug_defconfig"'.vendor_ramdisk_kernel_modules)
    ;;
    "duo2_gki_defconfig")
    export VENDOR_RAMDISK_KERNEL_MODULES=$(cat ${BUILD_PATH}/device_build/kernel/kernel.json | jq -r '."lahaina-gki_defconfig"'.vendor_ramdisk_kernel_modules)
    ;;
    "duo2_qgki_defconfig")
    export VENDOR_RAMDISK_KERNEL_MODULES=$(cat ${BUILD_PATH}/device_build/kernel/kernel.json | jq -r '."lahaina-qgki_defconfig"'.vendor_ramdisk_kernel_modules)
    ;;
    *)
    echo "Warning: Unknown config '$KERNCONFIG_NAME'. Using default 'lahaina-qgki_defconfig' module list."
    export VENDOR_RAMDISK_KERNEL_MODULES=$(cat ${BUILD_PATH}/device_build/kernel/kernel.json | jq -r '."lahaina-qgki_defconfig"'.vendor_ramdisk_kernel_modules)
    ;;
esac
echo "Vendor Ramdisk Modules: ${VENDOR_RAMDISK_KERNEL_MODULES}"

# --- 3. Build Functions (from buildkernel.sh) ---

make_defconfig()
{
    echo "======================"
    echo "Building defconfig"
    set -x
    (cd ${KERNEL_DIR} && \
    ${MAKE_PATH}make O=${OUT_DIR} ${MAKE_ARGS} HOSTCFLAGS="${TARGET_INCLUDES}" HOSTLDFLAGS="${TARGET_LINCLUDES}" ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} ${DEFCONFIG})
    set +x
}

headers_install()
{
    echo "======================"
    echo "Installing kernel headers"
    set -x
    # Create the directory first
    mkdir -p ${KERNEL_HEADERS_INSTALL}
    (cd ${KERNEL_DIR} && \
    ${MAKE_PATH}make HOSTCFLAGS="${TARGET_INCLUDES}" HOSTLDFLAGS="${TARGET_LINCLUDES}" ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} O=${OUT_DIR} ${CC_ARG} ${MAKE_ARGS} headers_install)
    set +x
}

build_kernel()
{
    echo "======================"
    echo "Building kernel"
    set -x
    if [ -f "${ROOT_DIR}/prebuilts/build-tools/linux-x86/bin/toybox" ]; then
        NCORES=$(${ROOT_DIR}/prebuilts/build-tools/linux-x86/bin/toybox nproc)
    else
        NCORES=$(nproc)
    fi
    (cd ${KERNEL_DIR} && \
    ${MAKE_PATH}make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} HOSTCFLAGS="${TARGET_INCLUDES}" HOSTLDFLAGS="${TARGET_LINCLUDES}" O=${OUT_DIR} ${CC_ARG} ${MAKE_ARGS} -j${NCORES})
    set +x
}

modules_install()
{
    echo "======================"
    echo "Installing kernel modules"
    rm -rf ${MODULES_STAGING_DIR}
    mkdir -p ${MODULES_STAGING_DIR}
    set -x
    (cd ${KERNEL_DIR} && \
    ${MAKE_PATH}make O=${OUT_DIR} ${CC_ARG} INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=${MODULES_STAGING_DIR} ${MAKE_ARGS} modules_install)
    set +x
    
    # Copy modules from staging to the final kernel modules out directory
    echo "Copying modules to final location: ${KERNEL_MODULES_OUT}"
    mkdir -p ${KERNEL_MODULES_OUT}
    MODULES=$(find ${MODULES_STAGING_DIR} -type f -name "*.ko")
    if [ -n "${MODULES}" ]; then
        for FILE in ${MODULES}; do
            cp -p ${FILE} ${KERNEL_MODULES_OUT}
        done
    fi
    
    # Copy blocklist
    BLOCKLIST_FILE=${BUILD_PATH}/device_build/modules.blocklist.${TARGET_PRODUCT}
	if [ -f "${BLOCKLIST_FILE}" ]; then
		cp ${BLOCKLIST_FILE} ${KERNEL_MODULES_OUT}/modules.blocklist
		sed -i -e '/blocklist/ s/-/_/g' ${KERNEL_MODULES_OUT}/modules.blocklist
	fi
}

archive_kernel_modules()
{
    echo "======================"
    echo "Archiving kernel modules"
    pushd ${KERNEL_MODULES_OUT}

    # Zip the vendor-ramdisk kernel modules
    FINAL_RAMDISK_KERNEL_MODULES=""
    for MODULE in ${VENDOR_RAMDISK_KERNEL_MODULES}; do
        if [ -f "${MODULE}" ]; then
            FINAL_RAMDISK_KERNEL_MODULES="${FINAL_RAMDISK_KERNEL_MODULES} ${MODULE}"
        fi
    done

    echo "Archiving vendor ramdisk kernel modules: "
    echo ${FINAL_RAMDISK_KERNEL_MODULES}

    if [ ! -z "${FINAL_RAMDISK_KERNEL_MODULES}" ]; then
        #MSCHANGE - generate vendor_boot_modules.load from ${VENDOR_RAMDISK_KERNEL_MODULES} and save to ${VENDOR_RAMDISK_KERNEL_MODULES_ARCHIVE}
        echo ${VENDOR_RAMDISK_KERNEL_MODULES} | tr " " "\n" > vendor_boot_modules.load
        zip -rq ${VENDOR_RAMDISK_KERNEL_MODULES_ARCHIVE} vendor_boot_modules.load ${FINAL_RAMDISK_KERNEL_MODULES}
        #MSCHANGE end
    fi

    # Filter-out the modules in vendor-ramdisk and zip the vendor kernel modules
    VENDOR_KERNEL_MODULES=$(ls *.ko | grep -v -f <(echo "${FINAL_RAMDISK_KERNEL_MODULES}" | tr ' ' '\n') || true)

    echo "Archiving vendor kernel modules: "
    echo ${VENDOR_KERNEL_MODULES}

    # Also package the modules.blocklist file
    set -x
    BLOCKLIST_FILE=""
    if [ -f "modules.blocklist" ]; then
        BLOCKLIST_FILE="modules.blocklist"
    fi

    if [ ! -z "${VENDOR_KERNEL_MODULES}" ]; then
        zip -rq ${VENDOR_KERNEL_MODULES_ARCHIVE} ${VENDOR_KERNEL_MODULES} ${BLOCKLIST_FILE}
    else
        echo "No vendor kernel modules to archive."
    fi
    set +x

    popd
}

save_unstripped_modules()
{
    echo "======================"
    echo "Creating a copy of unstripped modules"
    rm -rf ${UNSTRIPPED_DIR}
    mkdir -p ${UNSTRIPPED_DIR}
    set -x

    (cd ${KERNEL_DIR} && \
    ${MAKE_PATH}make O=${OUT_DIR} ${CC_ARG} INSTALL_MOD_PATH=${UNSTRIPPED_DIR} ${MAKE_ARGS} modules_install)

    MODULES=$(find ${UNSTRIPPED_DIR} -type f -name "*.ko")
    if [ -n "${MODULES}" ]; then
        for MODULE in ${MODULES}; do
            MODULE_NAME=$(basename ${MODULE})
            CORRECTED_NAME=$(echo "${MODULE_NAME//-/$'_'}")
            # Copy to root of unstripped dir
            cp -p ${MODULE} ${UNSTRIPPED_DIR}/${MODULE_NAME}
            if [ "${MODULE_NAME}" != "${CORRECTED_NAME}" ]; then
                mv ${UNSTRIPPED_DIR}/${MODULE_NAME} ${UNSTRIPPED_DIR}/${CORRECTED_NAME}
            fi
        done
        # Remove the /lib/modules/$(uname -r) hierarchy
        rm -rf ${UNSTRIPPED_DIR}/lib
    fi

    set +x
}

# --- 4. Main Build Execution ---
echo "Starting build for ${KERNCONFIG_NAME}"
echo "Output directory: ${OUT_DIR}"

# Create output directories
mkdir -p ${OUT_DIR}
mkdir -p ${KERNEL_MODULES_OUT}
mkdir -p ${UNSTRIPPED_DIR}
mkdir -p ${MODULES_STAGING_DIR}
mkdir -p ${DIST_DIR}

# Run the build steps
make_defconfig
headers_install
build_kernel
modules_install
archive_kernel_modules
save_unstripped_modules

echo "=================================================="
echo "Build complete!"
echo "Kernel image: ${OUT_DIR}/arch/arm64/boot/Image"
echo "DTBO image:   ${OUT_DIR}/arch/arm64/boot/dtbo.img"
echo "Modules:      ${KERNEL_MODULES_OUT}"
echo "Module Archives: ${KERNEL_MODULES_OUT}/${VENDOR_KERNEL_MODULES_ARCHIVE}, ${KERNEL_MODULES_OUT}/${VENDOR_RAMDISK_KERNEL_MODULES_ARCHIVE}"
echo "=================================================="

exit 0