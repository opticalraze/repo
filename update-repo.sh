#!/bin/bash

# =============================================
# Jailbreak Repo Packages Updater
# Run this script every time you add/remove .deb files
# =============================================

REPO_ROOT="$(pwd)"
DEBS_DIR="./debs"

echo "🔄 Updating jailbreak repository packages..."

# Check if debs directory exists
if [ ! -d "$DEBS_DIR" ]; then
    echo "❌ Error: $DEBS_DIR directory not found!"
    echo "Create a 'debs' folder and put your .deb files inside."
    exit 1
fi

# Count deb files
DEB_COUNT=$(ls -1 "$DEBS_DIR"/*.deb 2>/dev/null | wc -l)
echo "📦 Found $DEB_COUNT .deb file(s)"

if [ "$DEB_COUNT" -eq 0 ]; then
    echo "⚠️  No .deb files found in $DEBS_DIR"
    exit 1
fi

# Generate Packages file
echo "📋 Generating Packages file..."
dpkg-scanpackages -m "$DEBS_DIR" /dev/null > Packages

# Generate compressed versions
echo "🗜️  Compressing Packages..."
bzip2 -c -k Packages > Packages.bz2
gzip -c -k Packages > Packages.gz

# Update Release file with new hashes (Recommended)
echo "🔐 Updating Release file with checksums..."

cat > Release << EOF
Origin: OpticalRaze
Label: Optical Raze Jailbreak Repo
Suite: stable
Version: 1.0
Codename: ios
Architectures: iphoneos-arm iphoneos-arm64
Components: main
Description: Jailbreak tweaks and themes for iOS by Optical Raze
Date: $(date -u +"%a, %d %b %Y %H:%M:%S %Z")
EOF

# Add MD5, SHA1, SHA256 sums
{
    echo "MD5Sum:"
    printf " %s %8d %s\n" "$(md5sum Packages | cut -d' ' -f1)" "$(wc -c < Packages)" "Packages"
    printf " %s %8d %s\n" "$(md5sum Packages.gz | cut -d' ' -f1)" "$(wc -c < Packages.gz)" "Packages.gz"
    printf " %s %8d %s\n" "$(md5sum Packages.bz2 | cut -d' ' -f1)" "$(wc -c < Packages.bz2)" "Packages.bz2"
    
    echo "SHA1:"
    printf " %s %8d %s\n" "$(sha1sum Packages | cut -d' ' -f1)" "$(wc -c < Packages)" "Packages"
    printf " %s %8d %s\n" "$(sha1sum Packages.gz | cut -d' ' -f1)" "$(wc -c < Packages.gz)" "Packages.gz"
    printf " %s %8d %s\n" "$(sha1sum Packages.bz2 | cut -d' ' -f1)" "$(wc -c < Packages.bz2)" "Packages.bz2"
    
    echo "SHA256:"
    printf " %s %8d %s\n" "$(sha256sum Packages | cut -d' ' -f1)" "$(wc -c < Packages)" "Packages"
    printf " %s %8d %s\n" "$(sha256sum Packages.gz | cut -d' ' -f1)" "$(wc -c < Packages.gz)" "Packages.gz"
    printf " %s %8d %s\n" "$(sha256sum Packages.bz2 | cut -d' ' -f1)" "$(wc -c < Packages.bz2)" "Packages.bz2"
} >> Release

echo "✅ Repository successfully updated!"
echo "   • Packages      ($(wc -c < Packages) bytes)"
echo "   • Packages.gz   ($(wc -c < Packages.gz) bytes)"
echo "   • Packages.bz2  ($(wc -c < Packages.bz2) bytes)"
echo "   • Release file updated with checksums"