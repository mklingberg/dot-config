#!/bin/bash
set -euo pipefail

# Bootstrap: clone dot-config to ~/.config and re-run from there.
# Fresh machine: curl -fsSL https://raw.githubusercontent.com/mklingberg/dot-config/main/.install.sh | bash
CONFIG_DIR="$HOME/.config"
CONFIG_REPO="https://github.com/mklingberg/dot-config.git"

if [ ! -d "$CONFIG_DIR/.git" ]; then
  # git on a fresh Mac needs the Command Line Tools
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "Installing Command Line Tools (finish the dialog)..."
    xcode-select --install || true
    until xcode-select -p >/dev/null 2>&1; do sleep 5; done
  fi

  if [ -e "$CONFIG_DIR" ]; then
    backup="$CONFIG_DIR.bak-$(date +%Y%m%d%H%M%S)"
    echo "Moving existing $CONFIG_DIR to $backup"
    mv "$CONFIG_DIR" "$backup"
  fi

  echo "Cloning dot-config to $CONFIG_DIR..."
  git clone "$CONFIG_REPO" "$CONFIG_DIR"
  # stdin is the piped script under curl | bash; hand the terminal back for sudo prompts
  exec "$CONFIG_DIR/.install.sh" </dev/tty
fi

# Homebrew

## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Put brew on PATH for the rest of this script (Apple Silicon: /opt/homebrew, Intel: /usr/local)
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
brew analytics off

## Formulae
echo "Installing Brew Formulae..."

### Essentials
brew install git
brew install gsl
brew install wget
brew install jq
brew install sketchybar
brew install gettext
brew install starship
brew install libyaml

### Development
brew install kubeseal
brew install openssl@3
brew install ca-certificates
brew install azure-cli
brew install podman
brew install podman-compose
brew install nvm
brew install git-filter-repo
brew install jsonnet

### Agent tools
brew install rtk

## Casks
echo "Installing Brew Casks..."

### Utilities
brew install --cask betterdisplay
brew install --cask bettertouchtool
brew install --cask bettermouse
brew install --cask raycast
brew install --cask spotify
brew install --cask nikitabobko/tap/aerospace
brew install --cask vishvavariya/notchy/notchy

### Terminals
brew install --cask ghostty

### Communication
brew install --cask slack
brew install --cask microsoft-teams

### Web
brew install --cask zen
brew install --cask google-chrome
brew install --cask firefox

### Fonts
brew install --cask sf-symbols
brew install --cask font-sf-mono
brew install --cask font-sf-pro
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-fira-code
brew install --cask font-fira-code-nerd-font
brew install --cask font-meslo-lg-nerd-font

### Development
brew install --cask dotnet-sdk
brew install --cask devtunnel
brew install --cask bruno
brew install --cask rider
brew install --cask visual-studio-code
brew install --cask podman-desktop
brew install --cask powershell
brew install --cask microsoft-azure-storage-explorer
brew install --cask git-credential-manager
brew install --cask github
brew install --cask orca

# macOS Settings
echo "Changing macOS defaults..."

defaults write com.apple.spaces spans-displays -bool false
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0; killall Dock

defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain _HIHideMenuBar -bool true

defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"

defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.Finder AppleShowAllFiles -bool true
# https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control
defaults write com.apple.dock expose-group-apps -bool true

defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Disable "Press and Hold" accent selector
defaults write -g ApplePressAndHoldEnabled -bool false

# When NSWindowShouldDragOnGesture is set to YES, it allows you to drag windows using a three-finger drag gesture on the trackpad
defaults write -g NSWindowShouldDragOnGesture YES

echo "Fonts and utils..."

# Installing Fonts
git clone https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git /tmp/SFMono_Nerd_Font
mv /tmp/SFMono_Nerd_Font/* $HOME/Library/Fonts
rm -rf /tmp/SFMono_Nerd_Font/

curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.32/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

# Create links to use .config (idempotent: skip if already linked)
link() {
  local src="$1" dest="$2"
  if [ -L "$dest" ] || [ -e "$dest" ]; then
    echo "Skipping $dest (already exists)"
  else
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
  fi
}

link ~/.config/zsh/zshrc ~/.zshrc
link ~/.config/zsh/zprofile ~/.zprofile
link ~/.config/vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
link ~/.config/vscode/keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json"

# Clone dotfile repos (idempotent: skip if already present)
clone_repo() {
  local url="$1" dest="$2"
  if [ -d "$dest/.git" ]; then
    echo "Skipping clone of $url ($dest already exists)"
  else
    git clone "$url" "$dest"
  fi
}

clone_repo https://github.com/mklingberg/dot-pi.git ~/.pi
clone_repo https://github.com/mklingberg/dot-agents.git ~/.agents

# Oh My Zsh + custom plugins (plugins list lives in zsh/custom.zsh)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  # KEEP_ZSHRC keeps the ~/.zshrc symlink above; RUNZSH/CHSH stop it hijacking the script
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes ZSH="$HOME/.oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
clone_repo https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
clone_repo https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Install Pi
curl -fsSL https://pi.dev/install.sh | sh

# Install RTK Agent
rtk init -g --agent pi

# Start Services
echo "Starting Services (grant permissions)..."
