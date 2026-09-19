# Neovim 0.12 Configuration

A small, plugin-free Neovim 0.12 configuration for macOS on Apple Silicon.
It uses a separate application name so it can coexist with an existing Neovim
0.11 setup.

## Requirements

- macOS on Apple Silicon
- Homebrew
- Neovim 0.12

Install Neovim from Homebrew and verify the versioned binary:

```sh
brew install neovim
/opt/homebrew/opt/neovim/bin/nvim --version
```

## Installation

Clone this repository as the `nvim-012` configuration:

```sh
git clone <repository-url> "$HOME/.config/nvim-012"
```

Add a dedicated launcher to `~/.zshrc`:

```zsh
nvim12() {
  NVIM_APPNAME=nvim-012 /opt/homebrew/opt/neovim/bin/nvim "$@"
}
```

Start a new shell, then launch the configuration:

```sh
nvim12
```

Neovim keeps this setup's data, state, and cache separate under directories
named `nvim-012`. Phase 1 installs no plugins or external tools.

## Health Checks

Run the following commands inside Neovim:

```vim
:checkhealth
:checkhealth vim.deprecated
```

The existing Neovim 0.11 binary and configuration remain unchanged and provide
the rollback path during setup.
