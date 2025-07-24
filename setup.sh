#!/bin/bash

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install OrbStack (instead of Docker Desktop)
brew install --cask orbstack

# Install Node.js (latest LTS)
brew install node

# Install VSCode
brew install --cask visual-studio-code

# Copy config files
cp .zshrc ~/
cp .gitconfig ~/
cp node/.npmrc ~/.npmrc

# Copy VSCode settings
VSCODE_USER_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER_SETTINGS_DIR"
cp vscode/settings.json "$VSCODE_USER_SETTINGS_DIR/settings.json"

# Install VSCode extensions if 'code' command is available
if command -v code &>/dev/null; then
  code --install-extension esbenp.prettier-vscode
  code --install-extension dbaeumer.vscode-eslint
else
  echo "VSCode 'code' command not found."
  echo "To enable it, open VSCode, press Cmd+Shift+P, type 'shell command', and select:"
  echo "Shell Command: Install 'code' command in PATH"
  echo "Then re-run this script to install extensions."
fi

echo "Setup complete! Please start OrbStack and VSCode from Applications."
