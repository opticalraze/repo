#!/bin/bash

# =============================================
# Jailbreak Repo Packages Updater
# Run this after adding/removing .deb files
# =============================================

REPO_ROOT="$(pwd)"
DEBS_DIR="./debs"

echo "🔄 Updating jailbreak repository..."

# Check debs directory
if [ ! -d "$DEBS_DIR" ]; then
    echo "❌ Error: $DEBS_DIR directory not found!"
    echo "Create a 'debs' folder and put your .deb files inside."
    exit 1
fi

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

# ==================== GENERATE packages.json ====================

echo "📄 Generating packages.json for website..."

cat > packages.json << EOF
{
  "packages": [
EOF

# Parse Packages file and convert to JSON
first=1
while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line == "Package:"* ]]; then
        package=$(echo "$line" | awk '{print $2}')
    elif [[ $line == "Name:"* ]]; then
        name=$(echo "$line" | sed 's/Name: //')
    elif [[ $line == "Version:"* ]]; then
        version=$(echo "$line" | awk '{print $2}')
    elif [[ $line == "Description:"* ]]; then
        description=$(echo "$line" | sed 's/Description: //')
    elif [[ $line == "" && -n "$package" ]]; then
        # End of package entry → write to JSON
        if [ $first -eq 0 ]; then
            echo "    }," >> packages.json
        fi
        first=0

        # Defaults for missing fields
        id=$(echo "$package" | tr '[:upper:]' '[:lower:]' | tr '.' '-')
        category="Tweaks"
        price="Free"
        icon="https://picsum.photos/id/$(shuf -i 100-300 -n 1)/200/200"

        cat >> packages.json << EOF
    {
      "id": "$id",
      "name": "$name",
      "description": "$description",
      "icon": "$icon",
      "version": "$version",
      "category": "$category",
      "price": "$price"
    }
EOF
        # Reset variables
        package=""
        name=""
        version=""
        description=""
    fi
done < Packages

# Close JSON array
echo "  ]" >> packages.json
echo "}" >> packages.json

# Update Release file
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

# Add checksums
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
echo "   • Packages       ($(wc -c < Packages) bytes)"
echo "   • Packages.gz    ($(wc -c < Packages.gz) bytes)"
echo "   • Packages.bz2   ($(wc -c < Packages.bz2) bytes)"
echo "   • packages.json  ($(wc -c < packages.json) bytes)"
echo "   • Release file updated"