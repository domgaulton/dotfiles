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

# Install VSCode
brew install --cask visual-studio-code

# Install Docker 
brew install docker
brew link docker

# Install Node.js (latest LTS)
brew install node

# Install PostgresSQL
brew install postgresql@14

# Install Table Plus
brew install --cask tableplus

# Gemini CLI
brew install gemini-cli

# Bruno
brew install --cask bruno

# WhatsApp
brew install --cask whatsapp

# Ollama
brew install ollama 
# Ollama README 
# option 1 `brew services start ollama` This will start Ollama and keep it running in the background, even after you restart your computer.
# option 2 `ollama serve`
# `ollama run mistral` // or any other LLM

## Jan.ai
brew install --cask jan
# Jan.ai README
# Install local model
# Currently using `DeepSeek-R1-0528` and `Mistral-7B` 

# Copy config files
cp .zshrc ~/
cp .gitconfig ~/
cp node/.npmrc ~/.npmrc
cp vscode/.prettierrc ~/.prettierrc

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  export RUNZSH=no
  export CHSH=no
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh already installed."
fi

# Set zsh as default shell if not already
if [ "$SHELL" != "/bin/zsh" ]; then
  chsh -s /bin/zsh
  echo "Default shell changed to zsh. You may need to log out and back in for this to take effect."
fi

# --- GitHub SSH Setup ---
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  echo "Generating a new SSH key for GitHub..."
  ssh-keygen -t ed25519 -C "domgaulton@gmail.com" -f "$HOME/.ssh/id_ed25519" -N ""
  eval "$(ssh-agent -s)"
  ssh-add "$HOME/.ssh/id_ed25519"
  echo "SSH key generated."

  echo "Copy the following SSH public key and add it to your GitHub account (https://github.com/settings/keys):"
  cat "$HOME/.ssh/id_ed25519.pub"
else
  echo "SSH key already exists."
fi


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

echo "Setup complete!"
