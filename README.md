# Neovim 0.12 Configuration

A small Neovim 0.12 configuration for macOS on Apple Silicon. It uses a
separate application name so it can coexist with an existing Neovim 0.11
setup.

## Requirements

- macOS on Apple Silicon
- Homebrew
- Neovim 0.12
- Git
- ripgrep (`rg`)
- fd
- Yazi
- Lua Language Server (`lua-language-server`)
- StyLua
- A Nerd Font for navigation icons

Install Neovim from Homebrew and verify the versioned binary:

```sh
brew install neovim
/opt/homebrew/opt/neovim/bin/nvim --version
```

Install the navigation and Lua development tools plus a Nerd Font with
Homebrew:

```sh
brew install ripgrep fd yazi lua-language-server stylua
brew install --cask font-meslo-lg-nerd-font
```

Configure the installed Nerd Font in Ghostty:

```ini
font-family = "MesloLGM Nerd Font Propo"
```

`rg` provides project text search, `fd` provides fast file discovery, and Yazi
handles interactive file operations. `lua-language-server` provides Lua LSP
features. StyLua formats Lua files explicitly with `<leader>cf` and before each
save.

Language servers, formatters, linters, CLIs, and SDKs are installed outside
Neovim and must be available on `$PATH`. Neovim configures and activates the
tools but does not install or update them.

### Language Tooling

`nvim-lspconfig` provides the base server profiles. Add only local extensions
or overrides under `after/lsp/<server>.lua`; Neovim discovers and merges these
files automatically. Enable each server explicitly with
`vim.lsp.enable("<server>")` in `lua/config/lsp.lua`.

Install new language servers and formatters with Homebrew or the language's
package manager. Register external formatters by filetype in
`lua/plugins/coding/conform.lua`. Conform prefers a configured external
formatter and uses LSP formatting when no external formatter is available.

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
named `nvim-012`.

On the first start, `vim.pack` asks for confirmation before installing the
registered plugins. Confirm the installation, then commit the generated
`nvim-pack-lock.json`. Later starts use the installed plugin and the revision
recorded in that lockfile.

## Plugin Updates

Update all registered plugins from inside Neovim:

```vim
:lua vim.pack.update()
```

Review the proposed changes in the confirmation buffer. Write the buffer with
`:write` to apply them or close it with `:quit` to discard them. Restart Neovim
after applying an update, review the lockfile diff, and commit the updated
`nvim-pack-lock.json` together with any required configuration changes.

To restore the plugin revisions from the committed lockfile after an unwanted
update, first restore `nvim-pack-lock.json` with Git. Restart Neovim, then run:

```vim
:lua vim.pack.update(nil, { offline = true, target = "lockfile" })
```

Review and apply the proposed rollback with `:write`, then restart Neovim.

## Health Checks

Run the following commands inside Neovim:

```vim
:checkhealth
:checkhealth vim.deprecated
:checkhealth vim.lsp
```

The existing Neovim 0.11 binary and configuration remain unchanged and provide
the rollback path during setup.
