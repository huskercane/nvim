-- config/settings.lua

local opt = vim.opt
local g = vim.g

opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.smartcase = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.updatetime = 300
opt.signcolumn = "yes"
opt.wildmode = "list:longest"
opt.hidden = true
opt.shortmess:append("c")

g.git_messenger_include_diff = true

