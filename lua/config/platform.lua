-- config/platform.lua
-- Single source of truth for anything that differs by OS or by machine.
--
-- Switching machines should mean either nothing (the committed per-OS
-- `defaults` below cover the common case) or, at most, editing
-- lua/config/local.lua (gitignored) for paths/tools unique to one box.
-- No plugin spec or LSP config should hardcode an OS path again — read it
-- from here instead.

local uname = vim.loop.os_uname().sysname
local M = {}

M.is_windows = uname == "Windows_NT" or uname:find("MINGW") ~= nil or uname:find("MSYS") ~= nil
M.is_mac     = uname == "Darwin"
M.is_linux   = uname == "Linux"
M.name = M.is_windows and "windows" or M.is_mac and "mac" or "linux"

-- Path helpers
M.sep     = M.is_windows and "\\" or "/"   -- path separator
M.exe     = M.is_windows and ".exe" or ""  -- executable suffix
M.pathsep = M.is_windows and ";" or ":"    -- $PATH list separator

-- jdtls ships one launcher config dir per OS
M.jdtls_config_dir = ({ windows = "config_win", mac = "config_mac", linux = "config_linux" })[M.name]

-- Is a binary available (on PATH, or an absolute path)?
function M.has(bin)
  return vim.fn.executable(bin) == 1
end

-- Committed per-OS defaults. This is a personal dotfiles repo, so concrete
-- paths are fine to keep here. Anything you'd rather not commit, or that is
-- unique to a single machine, goes in local.lua and overrides these.
local defaults = {
  windows = {
    java_home = "D:\\.jdks\\corretto-21.0.11",
    java_runtimes = {
      { name = "JavaSE-21", path = "D:\\.jdks\\corretto-21.0.11", default = true },
      { name = "JavaSE-11", path = "D:\\.jdks\\corretto-11.0.31" },
    },
    gradle_executable = "gradlew.bat",
  },
  linux = {
    java_home = vim.env.JAVA_HOME, -- nil here -> jdtls falls back to `java` on PATH
    gradle_executable = "gradlew",
  },
  mac = {
    java_home = vim.env.JAVA_HOME,
    gradle_executable = "gradlew",
  },
}

-- Merge machine-local overrides from lua/config/local.lua (gitignored).
-- Set a key to a value to override; set java_home = false to disable jdtls
-- on a machine whose OS default would otherwise provide one.
local resolved = vim.tbl_extend("force", defaults[M.name] or {}, (function()
  local ok, cfg = pcall(require, "config.local")
  return (ok and type(cfg) == "table") and cfg or {}
end)())

M.java_home         = resolved.java_home or nil
M.java_runtimes     = resolved.java_runtimes
M.gradle_executable = resolved.gradle_executable or "gradlew"
M.disabled_servers  = resolved.disabled_servers or {}
M.disabled_plugins  = resolved.disabled_plugins or {}

-- Has this server/plugin been disabled for this machine via local.lua?
function M.disabled(kind, name)
  local list = kind == "server" and M.disabled_servers or M.disabled_plugins
  return vim.tbl_contains(list, name)
end

return M
