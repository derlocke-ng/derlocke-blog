#!/bin/bash
# Generate transparency manifest for derlocke.net
# This creates a cryptographic record of all deployed files

set -e

MANIFEST_DIR="transparency"
MANIFEST_FILE="$MANIFEST_DIR/manifest.json"
OUTPUT_DIR="${1:-.}"

mkdir -p "$MANIFEST_DIR"

# Get git information
GIT_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
GIT_COMMIT_SHORT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
GIT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "unknown")
BUILD_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
BUILD_HOST=$(hostname)

echo "🔐 Generating transparency manifest..."
echo "   Commit: $GIT_COMMIT_SHORT"
echo "   Branch: $GIT_BRANCH"

# Files to hash (exclude transparency dir itself, git, and sensitive files)
FILES_TO_HASH=$(find "$OUTPUT_DIR" -type f \
  \( -name "*.html" -o -name "*.css" -o -name "*.js" -o -name "*.md" \) \
  ! -path "./.git/*" \
  ! -path "./transparency/*" \
  ! -name "*.sig" \
  ! -name "CNAME" \
  | sort)

# Start JSON manifest
cat > "$MANIFEST_FILE" << EOF
{
  "version": "1.0",
  "generated": "$BUILD_TIME",
  "generator": "derlocke-blog/generate-manifest.sh",
  "git": {
    "commit": "$GIT_COMMIT",
    "commit_short": "$GIT_COMMIT_SHORT",
    "branch": "$GIT_BRANCH",
    "remote": "$GIT_REMOTE"
  },
  "verification": {
    "github_url": "https://github.com/derlocke-ng/derlocke-blog",
    "raw_url_base": "https://raw.githubusercontent.com/derlocke-ng/derlocke-blog/$GIT_COMMIT",
    "instructions": "Run verify.sh or manually compare SHA256 hashes"
  },
  "files": [
EOF

# Generate hashes
FIRST=true
for file in $FILES_TO_HASH; do
  if [ -f "$file" ]; then
    HASH=$(sha256sum "$file" | cut -d' ' -f1)
    SIZE=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
    RELPATH="${file#./}"
    
    if [ "$FIRST" = true ]; then
      FIRST=false
    else
      echo "," >> "$MANIFEST_FILE"
    fi
    
    printf '    {\n      "path": "%s",\n      "sha256": "%s",\n      "size": %s\n    }' \
      "$RELPATH" "$HASH" "$SIZE" >> "$MANIFEST_FILE"
  fi
done

# Close JSON
cat >> "$MANIFEST_FILE" << EOF

  ],
  "integrity": {
    "manifest_hash": "PLACEHOLDER"
  }
}
EOF

# Calculate manifest hash (excluding the placeholder line)
MANIFEST_HASH=$(grep -v '"manifest_hash"' "$MANIFEST_FILE" | sha256sum | cut -d' ' -f1)
sed -i "s/PLACEHOLDER/$MANIFEST_HASH/" "$MANIFEST_FILE"

echo "   Generated: $MANIFEST_FILE"
echo "   Files hashed: $(echo "$FILES_TO_HASH" | wc -w)"

# GPG sign if key is available
if [ -n "$GPG_KEY_ID" ]; then
  echo "🔑 Signing manifest with GPG key: $GPG_KEY_ID"
  gpg --armor --detach-sign --local-user "$GPG_KEY_ID" -o "$MANIFEST_DIR/manifest.sig" "$MANIFEST_FILE"
  echo "   Signature: $MANIFEST_DIR/manifest.sig"
elif command -v gpg &>/dev/null && gpg --list-secret-keys 2>/dev/null | grep -q "sec"; then
  echo "ℹ️  GPG keys available. Set GPG_KEY_ID to enable signing."
fi

echo "✅ Transparency manifest complete"
