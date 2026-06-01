#!/bin/bash

# =============================================
# Jailbreak Repo Packages Updater
# Generates files into dist/ for deployment
# =============================================

# Version comparison function
compare_versions() {
    local a=$1 b=$2
    local IFS='.'
    read -ra arrA <<< "$a"
    read -ra arrB <<< "$b"
    for ((i=0; i<${#arrA[@]} || i<${#arrB[@]}; i++)); do
        local numA=${arrA[i]:-0}
        local numB=${arrB[i]:-0}
        if ((numA > numB)); then
            echo 1
            return
        elif ((numA < numB)); then
            echo -1
            return
        fi
    done
    echo 0
}

DEBS_DIR="debs"
DEPICTIONS_DIR="depictions"
DIST_DIR="dist"

echo "🔄 Updating jailbreak repository..."

# Check directories
if [ ! -d "$DEBS_DIR" ]; then
    echo "❌ Error: $DEBS_DIR directory not found!"
    exit 1
fi

DEB_COUNT=$(ls -1 "$DEBS_DIR"/*.deb 2>/dev/null | wc -l)
echo "📦 Found $DEB_COUNT .deb file(s)"

if [ "$DEB_COUNT" -eq 0 ]; then
    echo "⚠️  No .deb files found!"
    exit 1
fi

# Create repo structure
mkdir -p "$DIST_DIR/debs"
mkdir -p "$DIST_DIR/depictions"

# Copy files
cp -r "$DEPICTIONS_DIR"/* "$DIST_DIR/depictions/" 2>/dev/null || true
cp -r "$DEBS_DIR"/* "$DIST_DIR/debs/" 2>/dev/null || true

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

# ==================== Generate packages.json (Latest Version Only) ====================
echo "📄 Generating packages.json (latest version per tweak)..."

# Temporary files for processing
> temp_packages.txt

# Parse Packages and keep only latest version per bundle_id
current_bundle=""
current_name=""
current_version=""
current_desc=""

while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line == "Package:"* ]]; then
        current_bundle=$(echo "$line" | awk '{print $2}')
    elif [[ $line == "Name:"* ]]; then
        current_name=$(echo "$line" | sed 's/Name: //')
    elif [[ $line == "Version:"* ]]; then
        current_version=$(echo "$line" | awk '{print $2}')
    elif [[ $line == "Description:"* ]]; then
        current_desc=$(echo "$line" | sed 's/Description: //')
    elif [[ -z "$line" && -n "$current_bundle" ]]; then
        # End of package block
        icon_path="/depictions/${current_bundle}/icon.png"
        banner_path="/depictions/${current_bundle}/banner.png"

        echo "$current_bundle|$current_version|$current_name|$current_desc|$icon_path|$banner_path" >> temp_packages.txt

        # Reset
        current_bundle=""
        current_name=""
        current_version=""
        current_desc=""
    fi
done < Packages

# Now process temp file to keep only latest version
> unique_packages.txt

sort -t'|' -k1,1 -k2,2Vr temp_packages.txt | awk -F'|' '
{
    if (!seen[$1]) {
        print $0
        seen[$1] = 1
    }
}' > unique_packages.txt

# Generate final JSON
cat > packages.json << EOF
{
  "packages": [
EOF

id_counter=1
is_first=1

while IFS='|' read -r bundle version name desc icon banner; do
    if [ $is_first -eq 0 ]; then
        echo "    }," >> packages.json
    fi
    is_first=0

    cat >> packages.json << EOF
    {
      "id": $id_counter,
      "bundle_id": "$bundle",
      "name": "$name",
      "description": "$desc",
      "icon": "$icon",
      "banner": "$banner",
      "version": "$version",
      "category": "Tweaks",
      "price": "Free"
EOF
    id_counter=$((id_counter + 1))
done < unique_packages.txt

# Close JSON
if [ $is_first -eq 0 ]; then
    echo "    }" >> packages.json
fi
echo "  ]" >> packages.json
echo "}" >> packages.json

# Cleanup temp files
rm -f temp_packages.txt unique_packages.txt

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

echo "✅ Repository successfully updated in dist/! (packages.json contains latest versions only)"