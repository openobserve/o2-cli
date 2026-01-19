#!/bin/bash
# O2 CLI Quick Install Script

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
    x86_64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    armv7l) ARCH="armv7" ;;
    *)
        echo -e "${RED}Error: Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

# Configuration
VERSION=${VERSION:-latest}
INSTALL_DIR=${INSTALL_DIR:-/usr/local/bin}
REPO="openobserve/o2-cli"

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  O2 CLI Installer${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "OS:           $OS"
echo "Architecture: $ARCH"
echo "Version:      $VERSION"
echo "Install Dir:  $INSTALL_DIR"
echo ""

# Check if install directory is writable
if [ ! -w "$INSTALL_DIR" ] && [ "$INSTALL_DIR" = "/usr/local/bin" ]; then
    NEED_SUDO=true
    echo -e "${YELLOW}Note: Will use sudo for installation${NC}"
else
    NEED_SUDO=false
fi

# Determine download URL
if [ "$VERSION" = "latest" ]; then
    # Get latest release tag
    echo "Fetching latest version..."
    VERSION=$(curl -sL "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | cut -d'"' -f4)
    if [ -z "$VERSION" ]; then
        echo -e "${RED}Error: Could not determine latest version${NC}"
        exit 1
    fi
    echo "Latest version: $VERSION"
fi

# Build download URL - matches GoReleaser naming format
FILENAME="o2-${OS}-${ARCH}.tar.gz"
URL="https://github.com/$REPO/releases/download/$VERSION/$FILENAME"

echo ""
echo "Downloading O2 CLI..."
echo "URL: $URL"

# Create temp directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

cd "$TMP_DIR"

# Download
if ! curl -sLf "$URL" -o "$FILENAME"; then
    echo -e "${RED}Error: Failed to download from $URL${NC}"
    echo "This might mean:"
    echo "  1. Version $VERSION doesn't exist"
    echo "  2. No binary for $OS/$ARCH"
    echo "  3. Network issue"
    exit 1
fi

echo "Extracting..."
tar xzf "$FILENAME"

# Install
echo "Installing to $INSTALL_DIR..."
if [ "$NEED_SUDO" = true ]; then
    sudo mv o2 "$INSTALL_DIR/o2"
    sudo chmod +x "$INSTALL_DIR/o2"
else
    mv o2 "$INSTALL_DIR/o2"
    chmod +x "$INSTALL_DIR/o2"
fi

# Verify installation
if command -v o2 &> /dev/null; then
    INSTALLED_VERSION=$(o2 --version 2>&1 | head -1)
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  ✅ O2 CLI installed successfully!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Installed: $INSTALLED_VERSION"
    echo "Location:  $(which o2)"
    echo ""
    echo "Next steps:"
    echo "  1. Configure: o2 configure"
    echo "  2. Try:       o2 dashboard list"
    echo "  3. Help:      o2 --help"
    echo ""
else
    echo -e "${YELLOW}Warning: o2 not found in PATH${NC}"
    echo "You may need to add $INSTALL_DIR to your PATH"
    echo "  export PATH=\$PATH:$INSTALL_DIR"
fi
