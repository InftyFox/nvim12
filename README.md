# Neovim 0.12 Configuration

A Neovim 0.12 configuration for macOS on Apple Silicon, using zsh and the
standard Homebrew prefix `/opt/homebrew`. It has been used with Neovim 0.12.5.
The `nvim12` launcher keeps its configuration, data, state, and cache separate
from an existing `nvim` installation.

Follow **Base Installation** for Lua, JSON, and YAML. Add only the optional
language profiles you need afterwards. Markdown is already usable with the
parsers included in Neovim; it needs no additional external tool.

Language servers, formatters, linters, CLIs, and SDKs are installed outside
Neovim. They must be available on the shell's `PATH`; this configuration does
not install or update them. Plugin configuration and usage are documented in
the Lua files.

## Base Installation

### 1. Prepare macOS and Homebrew

Install Apple's Command Line Tools if they are not already installed:

```sh
xcode-select --install
```

Wait for the installer to finish. If full Xcode or the Command Line Tools are
already selected, this step can be skipped. Verify the compiler is available:

```sh
xcrun --find clang
```

If Homebrew is not installed, run its installer as documented on
[brew.sh](https://brew.sh):

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow its post-installation instructions. For the standard Apple Silicon
installation, add this line once to `~/.zprofile`:

```zsh
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Open a new terminal, or load it in the current shell:

```sh
source "$HOME/.zprofile"
brew --version
```

### 2. Install Neovim and External Tools

```sh
brew install neovim git ripgrep fd yazi coreutils
brew install lua-language-server stylua
brew install vscode-langservers-extracted yaml-language-server
brew install --cask font-meslo-lg-nerd-font
```

The installed Neovim must be version 0.12.x:

```sh
/opt/homebrew/opt/neovim/bin/nvim --version
```

| Package | Required executables / purpose |
| --- | --- |
| `git` | Repository clone and package installation |
| `ripgrep`, `fd` | `rg` and `fd` for project searches |
| `yazi` | `yazi` and `ya` for file operations |
| `coreutils` | `grealpath` for relative file paths on macOS |
| `lua-language-server` | Lua language server |
| `stylua` | Lua formatter |
| `vscode-langservers-extracted` | `vscode-json-language-server` for JSON/JSONC |
| `yaml-language-server` | YAML language server |

Homebrew installs Node as a dependency of the JSON and YAML servers. No
separate npm installation is needed. macOS supplies `curl`, `tar`, `pbcopy`,
and `pbpaste`; keep them available for downloads, archives, and the clipboard.

Lua uses StyLua for formatting. JSON and YAML use language-server formatting;
no additional formatter or linter is needed for the base setup. YAML validation
against a specific schema needs a schema association in the file or project.

### 3. Configure zsh and the Terminal

Add this launcher to `~/.zshrc`:

```zsh
nvim12() {
  NVIM_APPNAME=nvim-012 /opt/homebrew/opt/neovim/bin/nvim "$@"
}
```

Select the installed Nerd Font in your terminal. For Ghostty, add this setting
to `~/.config/ghostty/config` and reload its configuration:

```ini
font-family = "MesloLGM Nerd Font Propo"
```

Open a new terminal to load the shell changes. Check the base executables:

```sh
command -v git curl tar rg fd yazi ya grealpath
command -v lua-language-server stylua node
command -v vscode-json-language-server yaml-language-server
command -v pbcopy pbpaste
```

The Homebrew tools should resolve under `/opt/homebrew/bin`. If an old Mason
directory takes precedence, adjust your shell's `PATH` so the Homebrew tools
are selected. `NVIM_APPNAME` separates Neovim's directories, but does not
isolate its inherited `PATH`.

### 4. Clone the Configuration

```sh
mkdir -p "$HOME/.config"
git clone https://github.com/InftyFox/nvim12.git "$HOME/.config/nvim-012"
```

The target directory must not already contain another configuration. If this
repository is already cloned there, use that checkout instead.

The repository includes `nvim-pack-lock.json`. Keep it with the configuration:
it records the plugin revisions to install on a fresh system.

### 5. First Start

The first start requires network access for package installation and the
prebuilt completion matcher download:

```sh
nvim12
```

Confirm the `vim.pack` installation prompt and wait for installation and
downloads to finish. The completion matcher has a prebuilt macOS Apple Silicon
binary; a Rust toolchain is not required. Restart Neovim after setup finishes.

Lua and Markdown parsers are included in Neovim. The base setup needs no
additional parser installation or `tree-sitter` CLI. The lockfile records
plugins, not separately compiled parsers.

### 6. Verify the Base Setup

Run these commands inside Neovim:

```vim
:checkhealth vim.deprecated
:checkhealth vim.lsp
:checkhealth vim.treesitter
:checkhealth blink.cmp
:checkhealth yazi
:messages
```

The completion health report should find the prebuilt matcher. Open a Lua file
in this checkout and representative JSON and YAML files; check the attached
servers with `:checkhealth vim.lsp` and confirm formatting on save. The enabled
base server names are `lua_ls`, `jsonls`, and `yamlls`.

Also check startup with a directory (`nvim12 .`). Once installation is complete,
restart without network access to confirm the installed packages and matcher
are sufficient. Files or projects that use remote schemas may still need the
network for those schemas.

Use `:checkhealth` for a broader report when needed. Missing tools for optional
features, such as parser compilation, do not mean the base installation is
incomplete.

## Optional Language Profiles

### C#

Skip this section if you do not need C#. The profile uses `csharp_ls` and has
been used with .NET 10 and `csharp-ls` 0.28.0. This server version requires a
.NET 10 runtime; a project may additionally require its own SDK version through
`global.json`.

#### Install the SDK and Language Server

```sh
brew install dotnet
```

For this Homebrew installation, add these lines to `~/.zshrc`:

```zsh
export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
export PATH="$HOME/.dotnet/tools:$PATH"
```

Open a new terminal, then install the tested language-server version:

```sh
dotnet tool install --global csharp-ls --version 0.28.0
dotnet --list-sdks
dotnet --list-runtimes
command -v csharp-ls
```

Confirm that .NET 10 is listed and `csharp-ls` resolves to
`$HOME/.dotnet/tools/csharp-ls`. If the global tool is already installed, inspect
its version with `dotnet tool list --global` rather than installing it again.
The `DOTNET_ROOT` above applies to Homebrew's `dotnet` formula; a different SDK
installation needs its own runtime location.

Restart `nvim12`. The existing configuration enables `csharp_ls` automatically
when `csharp-ls` is executable on `PATH`. Without that executable the server
stays disabled. No additional Lua configuration is needed for this profile.

#### Install the C# Parser

Follow [Parser Build Tools](#parser-build-tools), then run inside Neovim:

```vim
:TSInstall c_sharp
```

Wait for installation to finish, then reopen the C# file. The configuration
already associates the `cs` filetype with `c_sharp` and enables its highlighting
when the parser is installed. Without it, regular syntax highlighting remains
available.

#### Verify the Profile

Open a C# project containing a `.csproj`, `.sln`, or `.slnx` file so the server
can locate its root. Run:

```vim
:checkhealth vim.lsp
:checkhealth nvim-treesitter
:checkhealth vim.treesitter
:InspectTree
:messages
```

Confirm `csharp_ls` attaches to the expected project, diagnostics and completion
work, and formatting succeeds. Formatting uses the existing LSP fallback; no
separate C# formatter or linter is configured. Build and test commands remain
external to Neovim.

## Adding an Undocumented Language

Use this process for a language that has no dedicated chapter yet. Add a
dedicated profile chapter once its installation and configuration are working.

1. **Find the tools and server profile.** Browse the
   [nvim-lspconfig server configurations](https://github.com/neovim/nvim-lspconfig/tree/master/lsp)
   for server names, commands, filetypes, root detection, and settings. The
   [Mason Package Registry](https://github.com/mason-org/mason-registry/tree/main/packages)
   lists language servers, formatters, and linters; its package definitions link
   to upstream repositories and describe how the tools are distributed. Use
   these references to choose tools, then install them with Homebrew or the
   language's package manager.
2. **Install and verify the external tools.** Include the required SDK/runtime
   and `PATH` entries. Verify the executable paths from the same terminal that
   launches `nvim12`. Prefer project-local formatter and linter versions when
   the project defines them.
3. **Configure and enable the server.** For a provided profile, enable its name
   with `vim.lsp.enable("<server>")` in `lua/config/lsp.lua`. Add only local
   extensions or overrides in `after/lsp/<server>.lua`; Neovim discovers and
   merges them. For an optional profile, guard activation with an executable
   check as done for C#. If no base profile exists, define the command,
   filetypes, and project-root rules with `vim.lsp.config()` before enabling it.
4. **Configure formatting and filetype options.** Register an external formatter
   by filetype in `lua/plugins/coding/conform.lua` when needed. Otherwise the
   existing formatting policy falls back to a supporting attached LSP. Put
   indentation and other buffer-local settings in
   `after/ftplugin/<filetype>.lua`. Installing a linter alone does not integrate
   its diagnostics; configure that integration only when it is needed.
5. **Add a parser if needed.** Follow [Parser Build Tools](#parser-build-tools),
   then run `:TSInstall <parser>`. If the parser name differs from the filetype,
   register the association with `vim.treesitter.language.register()`. Explicitly
   enable highlighting for that filetype, using
   `lua/plugins/coding/treesitter.lua` as the existing example. Installing a
   parser alone does not enable highlighting.
6. **Verify in a representative project.** Check the filetype, server attachment,
   project root, diagnostics, completion, navigation, and formatting. For a
   newly installed parser, also check `:InspectTree`. Document the exact
   installation steps and project assumptions in the new profile chapter.

### Parser Build Tools

Install these only when a chosen language profile needs an additional parser:

```sh
brew install tree-sitter
tree-sitter --version
xcrun --find clang
command -v clang tar curl
```

The `tree-sitter` CLI must be version 0.26.1 or newer and installed through
Homebrew, not npm. A C compiler, `tar`, and `curl` must be available. The Command
Line Tools from the base installation provide the compiler.

Run parser installation commands after the first Neovim start has installed
the registered packages. If compilation fails, inspect `:TSLog`.

## Updates and Recovery

### External Tools

Update only the tools for profiles you use. Review the available Neovim version
with `brew info neovim` before upgrading it; this configuration targets 0.12.x.
For the base installation:

```sh
brew update
brew upgrade neovim git ripgrep fd yazi coreutils lua-language-server stylua vscode-langservers-extracted yaml-language-server
```

External tools are not pinned by `nvim-pack-lock.json`; review SDK and server
compatibility when updating an optional profile. For C#, keep the .NET 10
runtime available while using `csharp-ls` 0.28.0. Deliberately select and verify
a new server version
before replacing it with `dotnet tool update --global csharp-ls --version <version>`.

### Packages and Parsers

Update registered packages inside Neovim:

```vim
:lua vim.pack.update()
```

Review the confirmation buffer. Apply with `:write` or discard with `:quit`,
then restart Neovim. Review the `nvim-pack-lock.json` diff and keep the updated
lockfile with any required configuration changes. Blink is registered at a
fixed release tag; changing its release requires updating the tag in
`lua/config/packages.lua` deliberately.

After updating `nvim-treesitter`, update any additional parsers you installed
with `:TSUpdate`, or `:TSUpdate c_sharp` for C# alone. Skip this step if you use
only Neovim's bundled parsers. Reopen affected files afterwards.

To undo an unwanted package update, restore the previous lockfile revision
with Git, restart Neovim, then run:

```vim
:lua vim.pack.update(nil, { offline = true, target = "lockfile" })
```

Review and apply the rollback with `:write`, then restart again. If restoring
an older parser-manager revision, reinstall compatible additional parsers with
`:TSUpdate` as well. A lockfile rollback does not restore external tools.

The `nvim12` launcher leaves an existing Neovim 0.11 configuration separate;
if present, its launcher remains available during setup.

## Troubleshooting

| Problem | Check / action |
| --- | --- |
| `brew` is not found | Load Homebrew's `shellenv` from `~/.zprofile` and open a new terminal. |
| Wrong Neovim version or configuration | Run `/opt/homebrew/opt/neovim/bin/nvim --version`; inside `nvim12`, run `:lua print(vim.fn.stdpath("config"))` and expect `~/.config/nvim-012`. |
| A tool works only with the old setup | Use `command -v <tool>` to detect old Mason paths. In Neovim, `:lua print(vim.fn.exepath("<tool>"))` shows the inherited executable path. |
| Icons are missing | Select the installed Nerd Font in the terminal and reload its configuration. |
| A base language server does not attach | Check its executable, the detected filetype, and `:checkhealth vim.lsp`; inspect `:messages`. |
| C# does not attach | Check `csharp-ls`, the .NET runtime and `DOTNET_ROOT`, and the project-root files; restart after changing `PATH`. |
| Completion matcher download fails | Check Git, `curl`, network access, `:checkhealth blink.cmp`, and `:messages`; it may fall back to Lua with a warning. |
| Package installation fails | Restore the intended lockfile if installation changed it, fix the download problem, and restart. |
| Additional parser installation fails | Check the CLI version, compiler, `tar`, and `curl`; inspect `:TSLog`. |
| Shift-Enter behaves like Enter | Ensure the terminal sends a distinct Shift-Enter key; inspect `:verbose imap <S-CR>`. |
