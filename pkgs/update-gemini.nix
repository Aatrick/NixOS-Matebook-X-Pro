{ pkgs ? import <nixpkgs> {} }:

pkgs.writeShellScriptBin "update-gemini" ''
  # 1. Get the latest version from GitHub API (removes 'v' prefix)
  LATEST_TAG=$(${pkgs.curl}/bin/curl -s https://api.github.com/repos/google-gemini/gemini-cli/releases/latest | ${pkgs.jq}/bin/jq -r .tag_name)
  VERSION=''${LATEST_TAG#v}

  echo "Latest Gemini CLI version: $VERSION"

  # 2. Define the target file
  TARGET_FILE="pkgs/gemini-cli-latest.nix"
  
  # Check if we are in the right directory or find the file
  if [ ! -f "$TARGET_FILE" ]; then
     # Try to find it relative to the script execution if not in root of config
     if [ -f "config/$TARGET_FILE" ]; then
       TARGET_FILE="config/$TARGET_FILE"
     elif [ -f "../$TARGET_FILE" ]; then
       TARGET_FILE="../$TARGET_FILE"
     else
       echo "Error: Could not find $TARGET_FILE. Run this from your config root."
       exit 1
     fi
  fi

  # 3. Prefetch the new file to get the hash
  URL="https://github.com/google-gemini/gemini-cli/releases/download/v$VERSION/gemini.js"
  echo "Prefetching $URL..."
  NEW_HASH=$(${pkgs.nix}/bin/nix-prefetch-url $URL)
  # Convert to SRI hash format which nix prefers now (optional but good practice)
  SRI_HASH=$(${pkgs.nix}/bin/nix hash to-sri --type sha256 $NEW_HASH)

  echo "New Hash: $SRI_HASH"

  # 4. Update the file using sed
  # Update version
  ${pkgs.gnused}/bin/sed -i "s/version = \".*\";/version = \"$VERSION\";/" "$TARGET_FILE"
  # Update hash (handling potential SRI or base32 differences by matching the hash line generic pattern)
  ${pkgs.gnused}/bin/sed -i "s|hash = \".*\";|hash = \"$SRI_HASH\";|" "$TARGET_FILE"

  echo "Updated $TARGET_FILE to version $VERSION."
''