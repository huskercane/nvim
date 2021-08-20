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
paq {'bfrg/vim-qf-diagnostics'}

-- paq {'joshdick/onedark.vim'}
-- paq {'tomasiser/vim-code-dark'}
