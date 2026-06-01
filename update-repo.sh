#!/bin/bash

# =============================================
# Jailbreak Repo Packages Updater
# Generates files into dist/ for deployment
# =============================================

DEBS_DIR="debs"
DEPICTIONS_DIR="depictions"
DIST_DIR="dist"

echo "🔄 Updating jailbreak repository..."

# Check directories
if [ ! -d "$DEBS_DIR" ]; then
    echo "❌ Error: $DEBS_DIR directory not found!"
    exit 1
fi

if [ ! -d "$DEPICTIONS_DIR" ]; then
    echo "❌ Error: $DEPICTIONS_DIR directory not found!"
    exit 1
fi

DEB_COUNT=$(ls -1 "$DEBS_DIR"/*.deb 2>/dev/null | wc -l)
echo "📦 Found $DEB_COUNT .deb file(s)"

if [ "$DEB_COUNT" -eq 0 ]; then
    echo "⚠️  No .deb files found!"
    exit 1
fi

# Create repo structure in dist/
mkdir -p "$DIST_DIR/dists/stable/main/binary-amd64"
mkdir -p "$DIST_DIR/depictions"

# Copy depictions into dist/
cp -r "$DEPICTIONS_DIR"/* "$DIST_DIR/depictions/" 2>/dev/null || true

cd "$DIST_DIR" || exit 1

# Platform compatibility
if [[ "$OSTYPE" == "darwin"* ]]; then
    MD5_CMD="md5 -q"
    SHA1_CMD="shasum -a 1"
    SHA256_CMD="shasum -a 256"
    WC_CMD="wc -c"
else
    MD5_CMD="md5sum"
    SHA1_CMD="sha1sum"
    SHA256_CMD="sha256sum"
    WC_CMD="wc -c"
fi

# Generate Packages
echo "📋 Generating Packages file..."
dpkg-scanpackages -m "../$DEBS_DIR" /dev/null > Packages

echo "🗜️  Compressing Packages..."
bzip2 -c -k Packages > Packages.bz2
gzip -c -k Packages > Packages.gz

# ==================== Generate packages.json ====================
echo "📄 Generating clean packages.json..."

cat > packages.json << EOF
{
  "packages": [
EOF

id_counter=1
is_first=1

while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line == "Package:"* ]]; then
        bundle_id=$(echo "$line" | awk '{print $2}')
    elif [[ $line == "Name:"* ]]; then
        name=$(echo "$line" | sed 's/Name: //')
    elif [[ $line == "Version:"* ]]; then
        version=$(echo "$line" | awk '{print $2}')
    elif [[ $line == "Description:"* ]]; then
        description=$(echo "$line" | sed 's/Description: //')
    elif [[ $line == "" && -n "$bundle_id" ]]; then
        if [ $is_first -eq 0 ]; then
            echo "    }," >> packages.json
        fi
        is_first=0

        icon="/depictions/${bundle_id}/icon.png"
        banner="/depictions/${bundle_id}/banner.png"

        cat >> packages.json << EOF
    {
      "id": $id_counter,
      "bundle_id": "$bundle_id",
      "name": "$name",
      "description": "$description",
      "icon": "$icon",
      "banner": "$banner",
      "version": "$version",
      "category": "Tweaks",
      "price": "Free"
EOF
        id_counter=$((id_counter + 1))

        bundle_id=""
        name=""
        version=""
        description=""
    fi
done < Packages

# Close JSON properly
if [ $is_first -eq 0 ]; then
    echo "    }" >> packages.json
fi
echo "  ]" >> packages.json
echo "}" >> packages.json

# ==================== Generate Release file ====================
echo "🔐 Updating Release file..."
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

# Add Checksums
{
    echo "MD5Sum:"
    printf " %s %8d %s\n" "$($MD5_CMD Packages | awk '{print $1}')" "$($WC_CMD Packages | awk '{print $1}')" "Packages"
    printf " %s %8d %s\n" "$($MD5_CMD Packages.gz | awk '{print $1}')" "$($WC_CMD Packages.gz | awk '{print $1}')" "Packages.gz"
    printf " %s %8d %s\n" "$($MD5_CMD Packages.bz2 | awk '{print $1}')" "$($WC_CMD Packages.bz2 | awk '{print $1}')" "Packages.bz2"

    echo "SHA1:"
    printf " %s %8d %s\n" "$($SHA1_CMD Packages | awk '{print $1}')" "$($WC_CMD Packages | awk '{print $1}')" "Packages"
    printf " %s %8d %s\n" "$($SHA1_CMD Packages.gz | awk '{print $1}')" "$($WC_CMD Packages.gz | awk '{print $1}')" "Packages.gz"
    printf " %s %8d %s\n" "$($SHA1_CMD Packages.bz2 | awk '{print $1}')" "$($WC_CMD Packages.bz2 | awk '{print $1}')" "Packages.bz2"

    echo "SHA256:"
    printf " %s %8d %s\n" "$($SHA256_CMD Packages | awk '{print $1}')" "$($WC_CMD Packages | awk '{print $1}')" "Packages"
    printf " %s %8d %s\n" "$($SHA256_CMD Packages.gz | awk '{print $1}')" "$($WC_CMD Packages.gz | awk '{print $1}')" "Packages.gz"
    printf " %s %8d %s\n" "$($SHA256_CMD Packages.bz2 | awk '{print $1}')" "$($WC_CMD Packages.bz2 | awk '{print $1}')" "Packages.bz2"
} >> Release

cd - > /dev/null

echo "✅ Repository successfully updated in dist/!"