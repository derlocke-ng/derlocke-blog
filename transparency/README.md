# Code Transparency System

This directory contains the transparency and verification system for derlocke.net.

## What is this?

This system allows visitors to verify that the code running on the server matches
what's published on GitHub. It provides cryptographic proof of deployment integrity.

## Components

- `manifest.json` - Generated list of all deployed files with SHA256 hashes
- `manifest.sig` - GPG signature of the manifest (if GPG key configured)
- `verify.sh` - Script visitors can run to verify files match GitHub

## How it works

1. During build, `generate-manifest.sh` creates SHA256 hashes of all deployed files
2. The manifest includes the git commit hash and build timestamp
3. Optionally, the manifest is signed with a GPG key
4. Visitors can:
   - View the transparency page on the site
   - Download and run `verify.sh` to check files
   - Compare hashes against the GitHub source

## Verification

```bash
# Quick verification
curl -sL https://derlocke.net/transparency/verify.sh | bash

# Or download and inspect first (recommended)
wget https://derlocke.net/transparency/verify.sh
cat verify.sh  # Review the script
bash verify.sh
```

## For Server Operators

To enable GPG signing, set the `GPG_KEY_ID` environment variable:

```bash
export GPG_KEY_ID="your-gpg-key-id"
./build.sh
```
