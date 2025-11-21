#!/bin/bash
set -e  # Exit immediately if any command fails

# --- Configuration ---
EXTRACT_DIR="/buildd/temp_extract"
DEB_PATTERN="/buildd/linux-bootimage-5.4.233-microsoft-lahaina_*.deb"
ARCH="arm64"

echo ">>> Regenerating control file..."
rm -f debian/control
debian/rules debian/control

echo ">>> Building package for $ARCH..."
RELENG_HOST_ARCH="$ARCH" releng-build-package

echo ">>> Cleaning extract directory: $EXTRACT_DIR"
mkdir -p "$EXTRACT_DIR" # Ensure directory exists before cleaning
rm -rf "$EXTRACT_DIR"/*

echo ">>> Extracting package..."
# Finds the specific .deb file matching the pattern to avoid ambiguity
dpkg-deb -x $DEB_PATTERN "$EXTRACT_DIR/"

echo ">>> Done."
