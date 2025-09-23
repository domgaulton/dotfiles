#!/bin/bash

echo "📦 Updating Homebrew..."
brew update

echo "⬆️  Upgrading Homebrew packages..."
brew upgrade

echo "🧹 Cleaning up..."
brew cleanup

echo "✅ Brew upgrade complete!"