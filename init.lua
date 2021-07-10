require('settings')    -- lua/settings.lua
require('maps')    -- lua/settings.lua
local cmd = vim.cmd

cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq
paq{'savq/paq-nvim', opt=true}

paq {'nvim-treesitter/nvim-treesitter', run=':TSUpdate'}
paq {'nvim-treesitter/playground'}

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
paq {'joshdick/onedark.vim'}
paq {'morhetz/gruvbox'}
paq {'tomasiser/vim-code-dark'}
paq {'majutsushi/tagbar'}
paq {'Yggdroot/indentLine'}
paq {'martinda/Jenkinsfile-vim-syntax'}
paq {'tfnico/vim-gradle'}
paq {'vim-airline/vim-airline'}
paq {'vim-airline/vim-airline-themes'}
paq {'martinda/Jenkinsfile-vim-syntax'}
paq {'tfnico/vim-gradle'}
paq {'vim-airline/vim-airline'}
paq {'vim-airline/vim-airline-themes'}
paq {'kevinhwang91/nvim-bqf'}
paq {'rhysd/git-messenger.vim'}

local lsp = require 'lspconfig' 
lsp.pyright.setup{}
lsp.bashls.setup{}
lsp.dockerls.setup{}
lsp.jdtls.setup{
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
  }
}
lsp.solargraph.setup {}
lsp.gopls.setup{
	cmd = {"gopls", "serve"},
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
  }
}
lsp.sqls.setup{
    cmd = {"/home/rohits/work/projects/go/bin/sqls"},
    settings = {
    sqls = {
      connections = {
          -- {
          -- driver = 'mysql',
          -- dataSourceName = 'root:root@tcp(127.0.0.1:13306)/world',
        -- },
        -- {
          -- driver = 'postgresql',
          -- dataSourceName = 'host=127.0.0.1 port=15432 user=postgres password=mysecretpassword1234 dbname=dvdrental sslmode=disable',
        -- },
        {
            driver = 'sqlite3',
            dataSourceName = 'test.db',
        },
      },
    },
  },
}
lsp.jsonls.setup {
    commands = {
        Format = {
            function()
                vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
            end
        }
    }
}
lsp.tsserver.setup{}
local lsps = require 'lsp_signature'


-- make your Ctrl+x,Ctrl+o work, add this to your init.vim:
vim.api.nvim_command('autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc')

-- fix import like goimport
goimports = function(timeout_ms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit)
      end
      if type(action.command) == "table" then
        vim.lsp.buf.execute_command(action.command)
      end
    else
      vim.lsp.buf.execute_command(action)
    end
  end


vim.api.nvim_command('autocmd BufWritePre *.go lua goimports(1000)')

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

lsps.on_attach()
