# Neovim

Deployed to `~/.config/nvim` as a whole directory, so any file added here is
live immediately.

| Path                                        | Purpose                                                 |
| ------------------------------------------- | ------------------------------------------------------- |
| `init.lua`                                  | Entry point                                             |
| `lua/plugins.lua`                           | Plugin list, managed with Neovim's built-in `vim.pack`  |
| `lua/*.lua`                                 | Options, filetype detection, project and system helpers |
| `lua/autoload/`                             | Lazily loaded helpers                                   |
| `ftplugin/`, `after/ftplugin/`              | Per-filetype settings                                   |
| `indent/`, `after/indent/`, `after/syntax/` | Indent and syntax overrides                             |
| `compiler/`                                 | `:compiler` definitions                                 |
| `spell/`                                    | Custom dictionaries                                     |
| `autoload/`, `plugin/`                      | Vimscript autoload and always-loaded plugin files       |
| `ftdetect/`                                 | Filetype detection rules                                |
| `nvim-pack-lock.json`                       | Plugin lockfile written by `vim.pack`                   |
| `selene.toml`                               | Selene config for linting this Lua                      |
| `vim.yml`                                   | Selene standard library for Neovim (LuaJIT)             |

Plugins are pinned by `nvim-pack-lock.json`; update them from inside Neovim
rather than editing the lockfile.

`.petsfile` also declares the external tools the config expects: ripgrep, perl,
luarocks, ruby (apt only), and the npm `neovim` provider.
