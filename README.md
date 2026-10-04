# Neovim 0.12 Configuration

A small Neovim 0.12 configuration for macOS on Apple Silicon. It uses a
separate application name so it can coexist with an existing Neovim 0.11
setup.

## Requirements

- macOS on Apple Silicon
- Homebrew
- Neovim 0.12
- Git
- `curl` for Blink's prebuilt completion matcher download
- ripgrep (`rg`)
- fd
- Yazi
- Lua Language Server (`lua-language-server`)
- StyLua
- JSON Language Server (`vscode-json-language-server`)
- YAML Language Server (`yaml-language-server`)
- .NET SDK and C# Language Server (`csharp-ls`) for C# projects
- `tree-sitter-cli` 0.26.1 or newer, `tar`, `curl`, and a C compiler for additional Treesitter parsers
- A Nerd Font for navigation and Markdown icons

Install Neovim from Homebrew and verify the versioned binary:

```sh
brew install neovim
/opt/homebrew/opt/neovim/bin/nvim --version
```

Install the navigation, Lua, JSON, and YAML development tools plus a Nerd Font
with Homebrew:

```sh
brew install ripgrep fd yazi lua-language-server stylua
brew install vscode-langservers-extracted yaml-language-server
brew install --cask font-meslo-lg-nerd-font
```

Install the .NET SDK with Homebrew, then install the C# language server as a
global .NET tool:

```sh
brew install dotnet
dotnet tool install --global csharp-ls
```

Alternatively, install the .NET SDK using Microsoft's macOS installer before
installing `csharp-ls` with the `dotnet tool` command above.

Add the global .NET tools directory to `~/.zshrc` so Neovim started from an
interactive zsh session can find `csharp-ls`:

```zsh
export PATH="$HOME/.dotnet/tools:$PATH"
```

Open a new terminal and confirm that `command -v csharp-ls` resolves to
`~/.dotnet/tools/csharp-ls`. C# projects need a `.csproj`, `.sln`, or `.slnx`
file for the language server to find the project root.

Configure the installed Nerd Font in Ghostty:

```ini
font-family = "MesloLGM Nerd Font Propo"
```

`rg` provides project text search, `fd` provides fast file discovery, and Yazi
handles interactive file operations. `lua-language-server` provides Lua LSP
features. StyLua formats Lua files explicitly with `<leader>cf` and before each
save. The JSON and YAML language servers provide diagnostics and completion;
their LSP formatting is used with `<leader>cf` and on save. No separate JSON or
YAML formatter or linter is required. YAML validation against a particular
schema requires a schema association in the project or file.

`csharp-ls` provides C# diagnostics, completion, and navigation. C# formatting
uses the existing LSP fallback with `<leader>cf` and on save when the server
supports it; no separate C# formatter or linter is configured. The optional
`c_sharp` Treesitter parser adds syntax-tree highlighting and the class/function
context at the top of the window. C# files have the `cs` filetype, which this
config associates with the `c_sharp` parser. Until it is installed, C# retains
Neovim's regular syntax highlighting. Indentation continues to use Neovim's
existing filetype behavior even after parser installation; experimental
Treesitter indentation is not enabled.

`<leader>ca` requests native LSP code actions in Normal mode or for a Visual
selection. It requires an attached language server that supports code actions;
the available actions depend on the server and the selected code.

Markdown files use `render-markdown.nvim` for an in-editor rendered view in all
modes, with `mini.icons` for code-block language icons. Neovim 0.12 provides the
required `markdown` and `markdown_inline` parsers; no separate parser or
Markdown language server needs installing. The plugin provides checkbox and
callout completion through its in-process LSP. Markdown lines wrap visually at
word boundaries, without changing the file. No external Markdown formatter or
linter is configured.

`mini.ai` adds text objects such as `ab` (balanced brackets) and `aq` (quotes)
for Visual mode and operators, for example `vab` or `daq`. Its `an`/`in`
mappings deliberately use next-object search; `al`/`il` use last-object search.
Native incremental selection is preserved in Visual mode as `<leader>ls`
(expand to a parent node) and `<leader>lS` (shrink to a child node). Start with
`v`, then use these mappings repeatedly. They retain Neovim's LSP selection-range
fallback when no Treesitter parser is available and a supporting server is
attached. Native `[n`/`]n` node navigation and the `g]` tag command remain
available. `aF` selects a function definition including its signature; `iF`
selects its body. The exact ranges follow the language queries supplied by
`nvim-treesitter-textobjects` (the `main` branch), which is loaded as a query
provider for `mini.ai`. This includes Lua functions and C# methods/local
functions; for C# expression-bodied functions, `iF` selects the expression.
These text objects work in Visual mode (`vaF`, `viF`) and with operators
(`daF`, `ciF`). When adding a language supported by the provider's function
queries, install its parser; the same mappings work without local query files
or per-language mapping changes. Languages without those captures need an
upstream or local query addition. `mini.ai`'s default `af`/`if` still select
function calls. Class and conditional text objects are not mapped.

`mini.pairs` automatically closes brackets and quotes in Insert mode. Its default
rules skip pairing after a backslash and skip single-quote pairing after a
letter. Backspace removes an empty pair, and typing its closing character skips
over the existing one. Enter accepts the selected Blink completion when its menu
is visible; otherwise it inserts a pair-aware newline. Shift-Enter dismisses
completion without accepting it and always inserts that newline. Inside an empty
`()`, `[]`, or `{}` pair, the closing bracket moves to its own line, with the
cursor on the inner line. Indentation follows the existing filetype rules.
Elsewhere a normal newline is inserted; quotes are not split into an extra blank
line.
`mini.surround` adds, deletes, and replaces surroundings with `sa{motion}{char}`
(or `sa{char}` on a Visual selection), `sd{char}`, and `sr{old}{new}`.
`nvim-treesitter-context` pins the surrounding class or function at the top of
the window while scrolling in files with a suitable parser; it shows at most
three context lines. Indent and scope guides are not enabled.

Language servers, formatters, linters, CLIs, and SDKs are installed outside
Neovim and must be available on `$PATH`. Neovim configures and activates the
tools but does not install or update them.

### Language Tooling

`nvim-lspconfig` provides the `lua_ls`, `jsonls`, `yamlls`, and `csharp_ls`
base server profiles. Add only local extensions or overrides under
`after/lsp/<server>.lua`; Neovim discovers and merges these files
automatically. Enable each server explicitly with
`vim.lsp.enable("<server>")` in `lua/config/lsp.lua`.

Put filetype-specific editor options in `after/ftplugin/<filetype>.lua`. These
files apply to matching buffers; for example, `after/ftplugin/json.lua` sets
indentation options for JSON files.

Install new language servers and formatters with Homebrew or the language's
package manager. Register external formatters by filetype in
`lua/plugins/coding/conform.lua`. Conform prefers a configured external
formatter and uses LSP formatting when no external formatter is available.

To discover available language servers, formatters, and linters, browse the
[Mason package registry](https://github.com/mason-org/mason-registry/tree/main/packages).
Package definitions link to their upstream projects and show how the tools are
distributed. Use those references to identify the tools you need; this
configuration installs external tools through Homebrew or the language's
package manager.

## Completion

[`blink.cmp`](https://cmp.saghen.dev/) provides automatic insert-mode completion
using LSP results, file paths, and words from visible normal buffers. Buffer words
are a fallback when the LSP and path sources do not return candidates. The first
candidate is selected automatically, but navigating the menu does not insert text
until a candidate is accepted. The previous native LSP autocompletion is disabled
so only Blink owns the menu. Command-line completion remains native.

| Key | Action |
| --- | --- |
| Enter | Accept the selected completion, or insert a pair-aware newline if no completion is selected |
| Shift-Enter | Cancel completion and insert a pair-aware newline |
| Tab / Shift-Tab | Jump to the next / previous native snippet placeholder; otherwise use the normal key behavior |
| `Ctrl-n` / `Ctrl-p`, Down / Up | Select the next / previous completion |
| `Ctrl-Space` | Open completion, or toggle documentation when the menu is open |
| `Ctrl-e` | Close completion |
| `Ctrl-d` / `Ctrl-u` | Scroll completion documentation down / up by four lines; otherwise use the normal key behavior |
| `Ctrl-k` | Toggle signature help |

Documentation appears automatically without an added display delay when the
selected item provides it. Updates when switching items use Blink's default
50 ms delay. Experimental signature help is requested after accepting completion
and on language-server trigger characters, showing the function signature and
active parameter when the server provides them, without an additional
documentation block. Blink's default automatic
function brackets are enabled; `mini.pairs` handles manually typed brackets.
Ghost text is disabled. LSP-provided snippets expand through native `vim.snippet`;
no separate snippet provider or collection is enabled.

### Installation and Verification

Blink is pinned to the stable `v1.10.2` release through `vim.pack`. On your first
start after it is registered, confirm the plugin installation. Blink then uses
`curl` and Git to download the matching prebuilt Rust matcher for macOS Apple
Silicon automatically; a Rust toolchain is not required. If the matcher is
unavailable, the default `prefer_rust_with_warning` behavior falls back to Lua and
reports a warning. Typo resistance, frecency, and proximity ranking require the
Rust implementation. See the [matcher documentation](https://cmp.saghen.dev/configuration/fuzzy.html).

Wait for installation and the matcher download to finish, then restart Neovim.
Check `:checkhealth blink.cmp`, `:checkhealth vim.lsp`, and `:messages`. The Blink
health report should show the Rust matcher is available. The generated
`nvim-pack-lock.json` records Blink's revision and release tag; review it after
installation. Advancing Blink to another release requires deliberately changing
the registered tag before updating the plugin.

Verify automatic and manual completion in Lua, C#, JSON, YAML, and Markdown.
Check Markdown checkbox and callout suggestions from the existing
`render-markdown` LSP, plus path completion in a quoted relative path and buffer
word completion when neither LSP nor path suggestions are available. Check Enter,
Shift-Enter, snippet navigation, documentation scrolling, and signature help.
Function completion must not add duplicate brackets, and only one completion
menu should appear. Shift-Enter must arrive as a distinct key from the terminal;
verify `:verbose imap <S-CR>` if its behavior is unexpected.

For an isolated native snippet navigation check, run this command in a scratch
buffer, then use Tab and Shift-Tab between the placeholders:

```vim
:lua vim.snippet.expand("${1:first} ${2:second}$0")
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
named `nvim-012`.

On the first start, `vim.pack` asks for confirmation before installing the
registered plugins. Confirm the installation, then verify the configured
workflows before committing the generated `nvim-pack-lock.json`. Later starts
use the installed plugin and the revision recorded in that lockfile.

### Treesitter Parsers

Neovim includes parsers for Lua and Markdown. Additional parsers are installed
separately from the plugins; `nvim-pack-lock.json` pins plugins, not compiled
parsers. Install only the parsers needed for configured language profiles.
Currently C# needs the `c_sharp` parser for its syntax tree and pinned context.

On macOS, install the parser build tools yourself before installing a parser:

```sh
brew install tree-sitter
tree-sitter --version
xcrun --find clang
```

`tree-sitter-cli` must be version 0.26.1 or later. Install Apple's Command Line
Tools if `xcrun --find clang` cannot find a C compiler. `tar` and `curl` must
also be on `$PATH`. After the first Neovim start has installed the registered
plugins, install the C# parser inside Neovim:

```vim
:TSInstall c_sharp
```

Wait for the installation to finish, then reopen a C# file. Use
`:checkhealth nvim-treesitter`, `:checkhealth vim.treesitter`, `:Inspect`, and
`:InspectTree` to verify the parser and highlighting. If an install fails,
`:TSLog` shows the installer messages. To add another language later, first
check that it is actually needed, install its parser with `:TSInstall {parser}`,
and explicitly enable highlighting for its filetype, as done for C# in
`lua/plugins/coding/treesitter.lua`. Installing a parser alone does not enable
Treesitter highlighting.

## Plugin Updates

Update all registered plugins from inside Neovim:

```vim
:lua vim.pack.update()
```

Review the proposed changes in the confirmation buffer. Write the buffer with
`:write` to apply them or close it with `:quit` to discard them. Restart Neovim
after applying an update, review the lockfile diff, and commit the updated
`nvim-pack-lock.json` together with any required configuration changes.

After updating `nvim-treesitter`, run `:TSUpdate c_sharp` in Neovim to keep the
installed C# parser and its queries compatible with the plugin, then reopen the
C# file. `:TSUpdate` without an argument updates all parsers installed through
`nvim-treesitter`.

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
