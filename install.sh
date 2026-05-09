#!/bin/bash

set -e

INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/devstart"
SCRIPT_NAME="devstart"

echo "Installing project launcher..."

# 1. Ensure ~/.local/bin exists
mkdir -p "$INSTALL_DIR"

# 2. Copy script
cp devstart.sh "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo "Installed to $INSTALL_DIR/$SCRIPT_NAME"

# 3. Create config directory
mkdir -p "$CONFIG_DIR"

# 4. Create default config if not present
CONFIG_FILE="$CONFIG_DIR/config"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Enter the full path to your Projects directory:"
  read -r USER_PROJECTS_DIR

  # Expand ~ if the user typed it
  USER_PROJECTS_DIR="${USER_PROJECTS_DIR/#\~/$HOME}"

  # Validate path
  if [ ! -d "$USER_PROJECTS_DIR" ]; then
    echo "Directory does not exist: $USER_PROJECTS_DIR"
    echo "Run install again with a valid path."
    exit 1
  fi

  cat <<EOF > "$CONFIG_FILE"
# Project Launcher Config
PROJECTS_DIR="$USER_PROJECTS_DIR"
MAX_DEPTH=4
EOF

  echo "Config created at $CONFIG_FILE"
else
  echo "Config already exists. Skipping."
fi

echo "Done. Make sure ~/.local/bin is in your PATH."