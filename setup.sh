#!/bin/bash

# Setup script for bash aliases
# This script downloads and installs bash aliases from biTLegi0n/bash repository

set -e  # Exit immediately if a command exits with a non-zero status

# Set up logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting setup..."

# Define variables
DOWNLOAD_URL="https://github.com/biTLegi0n/bash/archive/refs/tags/0.1.0.tar.gz"
TAR_FILE="bash_alias.tar.gz"
EXTRACT_DIR="bash_aliases"

# Create temporary directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"
log "Working in temporary directory: $TMP_DIR"

# Download the tarball
log "Downloading bash aliases..."
if curl -Lk "$DOWNLOAD_URL" -o "$TAR_FILE"; then
    log "Download completed successfully"
else
    log "ERROR: Failed to download file"
    exit 1
fi

# Extract the tarball
log "Extracting files..."
if tar -xzf "$TAR_FILE"; then
    log "Extraction completed successfully"
else
    log "ERROR: Failed to extract archive"
    exit 1
fi

# List files for verification
log "Extracted files:"
ls -la "$EXTRACT_DIR"

# Copy bash aliases
log "Installing bash aliases..."
if cp "$EXTRACT_DIR/.bashrc" ~/.bash_aliases; then
    log "Bash aliases installed successfully"
else
    log "ERROR: Failed to copy bash aliases"
    exit 1
fi

# Source bash aliases
log "Applying new bash aliases..."
source ~/.bashrc 2>/dev/null || {
    log "NOTE: Could not automatically source ~/.bashrc"
    log "Please run 'source ~/.bashrc' manually to activate your bash aliases"
}

# Clean up
cd ~
log "Cleaning up temporary files..."
rm -rf "$TMP_DIR"

log "Setup completed successfully!"
log "Current directory: $(pwd)"