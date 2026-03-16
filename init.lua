-- init.lua

-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("config.settings")
require("config.keymaps")
require("config.autocmds")
require("lazy").setup("config.lazy")
require("config.cmp")
require("config.lsp")
require("config.debug")

