-- config/autocmds.lua

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local qf_group = augroup("QuickfixAuto", { clear = true })

autocmd({ "QuickFixCmdPost" }, {
  pattern = { "[^i]*", "l*" },
  command = "cwindow",
  group = qf_group,
})

autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

autocmd("FileType", {
  pattern = "go",
  command = "setlocal omnifunc=v:lua.vim.lsp.omnifunc",
})

