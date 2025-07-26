# Example zshrc content
export PATH="/usr/local/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="agnoster"

# Enable plugins
plugins=(git z)

# Sources for Oh My Zsh script, which applies the theme, plugins, and other settings.
source $ZSH/oh-my-zsh.sh

# Custom aliases
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gcm="git commit -m"
alias gp="git push"
alias python=python3
alias pip=pip3
