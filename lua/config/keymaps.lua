-- config/keymaps.lua

local map = vim.keymap.set

-- Completion menu navigation
map("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
map("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })

-- Telescope
-- local telescope = require("telescope.builtin")
-- map("n", "<leader>ff", telescope.find_files)
-- map("n", "<leader>fg", telescope.live_grep)
-- map("n", "<leader>fb", telescope.buffers)
-- map("n", "<leader>fh", telescope.help_tags)

-- Clipboard copy
map({ "n", "v" }, "<leader>c", '"+y')

-- Other
map("n", "<C-l>", "<cmd>noh<CR>")
map("n", "<leader>o", "m`o<Esc>``")
map("n", "<leader>cd", ":cd %:p:h<CR>")
map("n", "<leader>gm", ":GitMessenger<CR>")

