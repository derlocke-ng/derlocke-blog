#!/bin/bash
# Verification script for derlocke.net
# This script verifies that deployed files match the source on GitHub
#
# Usage:
#   curl -sL https://derlocke.net/transparency/verify.sh | bash
#   Or download and run locally: bash verify.sh [site_url]

set -e

SITE_URL="${1:-https://derlocke.net}"
MANIFEST_URL="$SITE_URL/transparency/manifest.json"
TEMP_DIR=$(mktemp -d)

cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

echo "🔐 derlocke.net Code Transparency Verifier"
echo "==========================================="
echo ""

# Download manifest
echo "📥 Fetching manifest from $MANIFEST_URL..."
if ! curl -sL "$MANIFEST_URL" -o "$TEMP_DIR/manifest.json"; then
  echo "❌ Failed to download manifest"
  exit 1
fi

# Parse manifest
COMMIT=$(jq -r '.git.commit' "$TEMP_DIR/manifest.json")
COMMIT_SHORT=$(jq -r '.git.commit_short' "$TEMP_DIR/manifest.json")
BRANCH=$(jq -r '.git.branch' "$TEMP_DIR/manifest.json")
BUILD_TIME=$(jq -r '.generated' "$TEMP_DIR/manifest.json")
GITHUB_URL=$(jq -r '.verification.github_url' "$TEMP_DIR/manifest.json")
RAW_BASE=$(jq -r '.verification.raw_url_base' "$TEMP_DIR/manifest.json")

echo ""
echo "📋 Deployment Info:"
echo "   Commit:  $COMMIT_SHORT ($COMMIT)"
echo "   Branch:  $BRANCH"
echo "   Built:   $BUILD_TIME"
echo "   Source:  $GITHUB_URL"
echo ""

# Check for GPG signature
SIG_URL="$SITE_URL/transparency/manifest.sig"
if curl -sL --head "$SIG_URL" 2>/dev/null | grep -q "200"; then
  echo "🔑 GPG signature found"
  curl -sL "$SIG_URL" -o "$TEMP_DIR/manifest.sig"
  
  if command -v gpg &>/dev/null; then
    echo "   Verifying signature..."
    if gpg --verify "$TEMP_DIR/manifest.sig" "$TEMP_DIR/manifest.json" 2>/dev/null; then
      echo "   ✅ Signature valid"
    else
      echo "   ⚠️  Signature verification failed (key may not be in your keyring)"
    fi
  else
    echo "   ℹ️  Install GPG to verify signature"
  fi
  echo ""
fi

# Verify files against GitHub
echo "🔍 Verifying files against GitHub source..."
echo ""

TOTAL=0
PASSED=0
FAILED=0
SKIPPED=0

FILE_COUNT=$(jq '.files | length' "$TEMP_DIR/manifest.json")

for i in $(seq 0 $((FILE_COUNT - 1))); do
  FILE_PATH=$(jq -r ".files[$i].path" "$TEMP_DIR/manifest.json")
  EXPECTED_HASH=$(jq -r ".files[$i].sha256" "$TEMP_DIR/manifest.json")
  
  TOTAL=$((TOTAL + 1))
  
  # Skip generated files that won't be in source
  if [[ "$FILE_PATH" == *.html ]] && [[ "$FILE_PATH" != *-template.html ]]; then
    # HTML files are generated, verify against deployed version instead
    DEPLOYED_URL="$SITE_URL/$FILE_PATH"
    ACTUAL_HASH=$(curl -sL "$DEPLOYED_URL" | sha256sum | cut -d' ' -f1)
    
    if [ "$EXPECTED_HASH" = "$ACTUAL_HASH" ]; then
      echo "   ✅ $FILE_PATH (deployed matches manifest)"
      PASSED=$((PASSED + 1))
    else
      echo "   ❌ $FILE_PATH (hash mismatch!)"
      FAILED=$((FAILED + 1))
    fi
  else
    # Source files - verify against GitHub
    GITHUB_RAW="$RAW_BASE/$FILE_PATH"
    ACTUAL_HASH=$(curl -sL "$GITHUB_RAW" 2>/dev/null | sha256sum | cut -d' ' -f1)
    
    if [ -z "$ACTUAL_HASH" ] || [ "$ACTUAL_HASH" = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" ]; then
      echo "   ⚠️  $FILE_PATH (not found on GitHub, may be generated)"
      SKIPPED=$((SKIPPED + 1))
    elif [ "$EXPECTED_HASH" = "$ACTUAL_HASH" ]; then
      echo "   ✅ $FILE_PATH"
      PASSED=$((PASSED + 1))
    else
      echo "   ❌ $FILE_PATH (source differs from deployed!)"
      echo "      Expected: $EXPECTED_HASH"
      echo "      GitHub:   $ACTUAL_HASH"
      FAILED=$((FAILED + 1))
    fi
  fi
done

echo ""
echo "==========================================="
echo "📊 Verification Summary"
echo "   Total files:  $TOTAL"
echo "   Verified:     $PASSED"
echo "   Failed:       $FAILED"
echo "   Skipped:      $SKIPPED"
echo ""

if [ $FAILED -eq 0 ]; then
  echo "✅ All verifiable files match their source!"
  echo ""
  echo "🔗 View source: $GITHUB_URL/tree/$COMMIT_SHORT"
  exit 0
else
  echo "⚠️  Some files did not match. This could indicate:"
  echo "   - Unauthorized modifications"
  echo "   - Build process differences"
  echo "   - CDN caching issues"
  echo ""
  echo "Please report concerns to: derlocke@derlocke.net"
  exit 1
fi
