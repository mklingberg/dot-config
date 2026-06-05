# ~/.config

An opinionated macOS setup for fast navigation, clean visuals, and low-friction development.

This repo is the part of my machine that actually matters: window management, status bars, terminal stack, editor defaults, theme syncing, and bootstrap scripts. Versioning it keeps the environment reproducible instead of slowly decaying into one-off GUI tweaks.

> Keyboard-first. Readable. Rebuildable.

## What defines the setup

### AeroSpace
The backbone of the desktop.

AeroSpace handles tiling, workspace movement, monitor assignment, and most of the navigation model. The config shows this is not just “installed” — it is the primary control layer:
- numbered workspaces
- hjkl-style focus and move bindings
- floating exceptions for specific apps
- monitor-aware workspace assignment
- hooks intended to integrate with SketchyBar

Config:
- `aerospace/aerospace.toml`

### SketchyBar
The visual layer on top of the window manager.

This setup uses SketchyBar as the status surface for workspace state and multi-display layouts. There are separate bar instances/configs for different displays, plus a startup script to launch them.

Relevant files:
- `sketchybar/sketchybarrc`
- `sketchybar-2/sketchybarrc`
- `sketchybar/theme.sh`
- `.start_on_login.sh`

### borders
A small component with high payoff.

`borders` makes focus state obvious, which matters more in a tiling setup than on a stock desktop. The current config uses rounded borders, hidpi support, and an app blacklist.

Config:
- `borders/bordersrc`

### Ghostty + Starship + Zsh
This is the real terminal stack.

Ghostty is the primary terminal, Starship provides the prompt, and Zsh carries aliases + shell customizations. Together they define most of the day-to-day command-line experience.

Relevant files:
- `ghostty/config`
- `starship/starship.toml`
- `zsh/zshrc`
- `zsh/aliases.zsh`
- `zsh/custom.zsh`

Notable details:
- Ghostty uses hidden titlebar, padded layout, and Catppuccin theme
- Starship is heavily customized, including git, cloud, Kubernetes, and .NET signal
- Zsh exposes quick git aliases and a `theme` helper

### Shared theme switching
One of the nicer parts of the setup.

`toggle-theme.sh` switches theme across multiple tools in one command instead of making theme drift inevitable.

It currently syncs:
- Ghostty
- Starship
- pi

Script:
- `toggle-theme.sh`

Usage:
```bash
theme frappe
theme macchiato
theme dracula
```

### VS Code
Editor defaults live here too, so the coding environment stays consistent.

The current settings suggest a practical coding setup: clean UI, JetBrains Mono, Catppuccin theme, Copilot enabled, Podman/devcontainer integration, and terminal/editor tuning.

Config:
- `vscode/settings.json`
- `vscode/keybindings.json`

### Bootstrap scripts
This repo also contains the “bring a new machine up fast” layer.

Relevant files:
- `.install.sh`
- `.start_on_login.sh`

These cover:
- Homebrew installs
- macOS defaults
- fonts
- symlinks into `$HOME`
- startup services

## Secondary / optional pieces

### WezTerm
Still configured, but looks secondary now rather than central.

Config:
- `wezterm/wezterm.lua`

### LinearMouse
There is active device-specific mouse tuning here, mainly for pointer/scroll behavior.

Config:
- `linearmouse/linearmouse.json`

## Why this repo exists

Good machine setup is not decoration. It is leverage.

A strong local environment should:
- reduce friction every hour
- make focus state obvious
- keep terminal/editor behavior consistent
- survive reinstalls and new machines

That is what this repo is for.