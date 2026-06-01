#!/bin/bash

# =============================================
# Jailbreak Repo Packages Updater
# Properly formatted packages.json (No extra commas/braces)
# =============================================

PUBLIC_DIR="./public"
DEBS_DIR="debs"

echo "🔄 Updating jailbreak repository..."

if [ ! -d "$PUBLIC_DIR" ]; then
    echo "❌ Error: $PUBLIC_DIR directory not found!"
    exit 1
fi

cd "$PUBLIC_DIR" || exit 1

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
dpkg-scanpackages -m "$DEBS_DIR" /dev/null > Packages

echo "🗜️  Compressing Packages..."
bzip2 -c -k Packages > Packages.bz2
gzip -c -k Packages > Packages.gz

# ==================== GENERATE packages.json ====================
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
        # Add comma before this object if it's not the first
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

# Close the last object and the array properly
if [ $is_first -eq 0 ]; then
    echo "    }" >> packages.json
fi

echo "  ]" >> packages.json
echo "}" >> packages.json

# Update Release file
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

# Checksums
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

echo "✅ Repository successfully updated!"
echo "   • packages.json should now be clean (no extra braces/commas)"