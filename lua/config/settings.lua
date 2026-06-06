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

-- Neovim 0.12.2's built-in Markdown ftplugin starts Treesitter
-- unconditionally, which currently crashes on some Markdown buffers.
local treesitter_start = vim.treesitter.start
vim.treesitter.start = function(bufnr, lang)
  bufnr = bufnr or 0
  lang = lang or vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  if lang == "markdown" then
    return
  end
  return treesitter_start(bufnr, lang)
end
