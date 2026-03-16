-- config/cmp.lua

local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

cmp.setup {
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-o>'] = cmp.mapping.complete_common_string(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm(),
  },
  sources = {
    { name = 'buffer', keyword_length = 3 },  -- only start autocompleting after a few chars typed
    { name = 'nvim_lsp', max_item_count = 10 },  -- don't overpopulate list with symbols from LSP
  },
  -- Just for aesthetics
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
}
