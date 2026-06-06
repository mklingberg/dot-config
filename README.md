# ~/.config

An opinionated macOS setup for fast navigation, clean visuals, and low-friction development.

This repo is the part of my machine that actually matters: window management, status bars, terminal stack, editor defaults, theme syncing, and bootstrap scripts. Versioning it keeps the environment reproducible instead of slowly decaying into one-off GUI tweaks.

> Keyboard-first. Readable. Rebuildable.

## What defines the setup

### AeroSpace
The backbone of the desktop.

AeroSpace handles tiling, workspace movement, monitor assignment, and most of the navigation model. The config shows this is not just "installed" - it is the primary control layer:
- numbered workspaces
- hjkl-style focus and move bindings
- floating exceptions for specific apps
- monitor-aware workspace assignment

Config:
- `aerospace/aerospace.toml`

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
This repo also contains the "bring a new machine up fast" layer.

Relevant files:
- `.install.sh`

These cover:
- Homebrew installs
- macOS defaults
- fonts
- symlinks into `$HOME`
- startup services

## Archived / retired pieces

Older or retired configs now live under `_archive/` instead of pretending they are still active.

That currently includes archived setups for:
- Borders
- SketchyBar
- older SketchyBar variants
- WezTerm
- older startup/login helpers

## Why this repo exists

Good machine setup is not decoration. It is leverage.

A strong local environment should:
- reduce friction every hour
- make focus state obvious
- keep terminal/editor behavior consistent
- survive reinstalls and new machines

That is what this repo is for.

## Related repos

- [dot-pi](https://github.com/mklingberg/dot-pi) - pi setup, agents, planning workflow
- [dot-config](https://github.com/mklingberg/dot-config) - macOS/dev environment config
- [dot-agents](https://github.com/mklingberg/dot-agents) - personal pi skill library