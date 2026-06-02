-- config/keymaps.lua

local map = vim.keymap.set

-- Tab/S-Tab: cycle vsnip snippets or cmp menu
map("i", "<Tab>", function()
  if vim.fn["vsnip#jumpable"](1) == 1 then
    return "<Plug>(vsnip-jump-next)"
  else
    return "<Tab>"
  end
end, { expr = true, remap = true })

map("i", "<S-Tab>", function()
  if vim.fn["vsnip#jumpable"](-1) == 1 then
    return "<Plug>(vsnip-jump-prev)"
  else
    return "<S-Tab>"
  end
end, { expr = true, remap = true })

-- Also in select mode for snippet placeholders
map("s", "<Tab>", function()
  if vim.fn["vsnip#jumpable"](1) == 1 then
    return "<Plug>(vsnip-jump-next)"
  else
    return "<Tab>"
  end
end, { expr = true, remap = true })

map("s", "<S-Tab>", function()
  if vim.fn["vsnip#jumpable"](-1) == 1 then
    return "<Plug>(vsnip-jump-prev)"
  else
    return "<S-Tab>"
  end
end, { expr = true, remap = true })

-- Clipboard copy
map({ "n", "v" }, "<leader>c", '"+y')

-- Other
map("n", "<C-l>", "<cmd>noh<CR>")
map("n", "<leader>o", "m`o<Esc>``")
map("n", "<leader>cd", ":cd %:p:h<CR>")
map("n", "<leader>gm", ":GitMessenger<CR>")

-- Start jdtls on demand in Java projects
map("n", "<leader>lj", function()
  if _G.start_java_lsp then
    _G.start_java_lsp(0)
  else
    vim.notify("start_java_lsp not loaded", vim.log.levels.ERROR)
  end
end, { desc = "Start Java LSP (jdtls)" })
