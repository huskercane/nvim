require('settings')    -- lua/settings.lua
require('maps')    -- lua/maps.lua
local cmd = vim.cmd

cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq
paq{'savq/paq-nvim', opt=true}

paq {'nvim-treesitter/nvim-treesitter', run=':TSUpdate'}
-- paq {'nvim-treesitter/playground'}

paq {'neovim/nvim-lspconfig'}
paq {'hrsh7th/nvim-compe'}
paq {'nvim-lua/popup.nvim'}
paq {'nvim-lua/plenary.nvim'}
paq {'nvim-telescope/telescope.nvim'}
paq {'ray-x/lsp_signature.nvim'}
paq {'jeetsukumaran/vim-markology'}
paq {'tpope/vim-fugitive'}
paq {'airblade/vim-gitgutter'}
paq {'vim-scripts/LargeFile'}
paq {'morhetz/gruvbox'}
paq {'majutsushi/tagbar'}
paq {'Yggdroot/indentLine'}
paq {'martinda/Jenkinsfile-vim-syntax'}
paq {'tfnico/vim-gradle'}
paq {'vim-airline/vim-airline'}
paq {'vim-airline/vim-airline-themes'}
paq {'kevinhwang91/nvim-bqf'}
paq {'rhysd/git-messenger.vim'}

-- paq {'joshdick/onedark.vim'}
-- paq {'tomasiser/vim-code-dark'}
require('lsp')    --- lua/lsp.lua

-- Compe setup
local compe = require 'compe'
compe.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
        path = true;
        nvim_lsp = true;
    };
}

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    else
        return t "<S-Tab>"
    end
end

local tag_file = function(ctag_dir)
	tag_files = {}
    local uv = require("luv")
    local scan_dir = function(err, success)
        -- check err
        if err ~= nil then return end
        while true do
            -- if file then add to tags list
            local name, type = uv.fs_scandir_next(success)
            if  name == nil then
                break
            end
            table.insert(tag_files, ctag_dir..'/'..name)
        end
    end

    scan_dir(nil, uv.fs_scandir(ctag_dir))
	vim.o.tags = table.concat(tag_files, ":")
end
tag_file('/Users/rohitsi/.ctags')
