# nvim

My Neovim configuration. Lazy.nvim for plugins, Neovim 0.11+ native LSP.

It runs across **Windows, macOS, and Linux** from the same checkout. Anything
that differs by OS or by machine funnels through one module, so switching
machines is either zero setup or a single local file.

## Layout

```
init.lua                  bootstrap + module load order
lua/config/
  platform.lua            OS detection, per-OS defaults, machine overrides  <- start here
  local.lua.example       template for machine-specific overrides (copy -> local.lua)
  local.lua               your overrides (gitignored, optional)
  settings.lua            editor options
  keymaps.lua             keymaps
  autocmds.lua            autocommands
  lazy.lua                plugin specs
  lsp.lua                 LSP servers + jdtls
  cmp.lua                 completion
  debug.lua               nvim-dap (loaded only in Go projects)
```

## Cross-platform model

`lua/config/platform.lua` is the single source of truth for anything
OS- or machine-dependent. No plugin spec or LSP config hardcodes an OS path —
they all read from `platform`. It provides:

- OS flags: `is_windows` / `is_mac` / `is_linux`, and `name` (`"windows"`/`"mac"`/`"linux"`)
- Path helpers: `sep`, `exe`, `pathsep`, `jdtls_config_dir`
- Resolved values: `java_home`, `java_runtimes`, `gradle_executable`
- `has(bin)` — is a binary available on this machine
- `disabled("server"|"plugin", name)` — per-machine opt-outs

Values resolve in this order (later wins):

1. **Committed per-OS defaults** in `platform.lua` (`defaults` table) — the common
   case, so a known OS works with no setup. Linux/macOS auto-pick `$JAVA_HOME`;
   Windows uses baked-in Corretto paths.
2. **`lua/config/local.lua`** (gitignored) — overrides for one specific machine.

### Per-machine overrides

Only needed when a machine differs from the OS default (odd JDK path, a missing
toolchain). Copy the template and edit:

```sh
cp lua/config/local.lua.example lua/config/local.lua
```

Common cases:

```lua
return {
  -- JDK in a non-standard place
  java_home = "/usr/lib/jvm/java-21-openjdk",

  -- disable jdtls entirely on this box
  -- java_home = false,

  -- no Go/Rust toolchain here: don't install or start these
  disabled_servers = { "gopls", "rust_analyzer" },
}
```

Omit any key to keep the default. `local.lua` is gitignored, so each machine
keeps its own without affecting the others.

## LSP

Servers are installed via Mason and enabled **only when the project matches**
(e.g. `gopls` when there's a `go.mod`, `pyright` for Python). A server listed in
`disabled_servers` is skipped on that machine even if the project matches.

### Java / jdtls

jdtls is **never auto-started** — it's heavy and not wanted in every Java buffer.
Start it on demand in a Java project:

- `<leader>lj` or `:JavaLspStart` — start jdtls for the current buffer
- `:JavaLspStatus` — show the last command, root dir, and active jdtls clients

The launcher, JDK, and config dir are all resolved from `platform`, so the same
command works on every OS. If no JDK is found it tells you to set `java_home` in
`local.lua`.
