vim.cmd 'packadd paq-nvim'
local paq = require('paq').paq
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
paq {'morhetz/gruvbox'}
paq {'majutsushi/tagbar'}
paq {'Yggdroot/indentLine'}
paq {'martinda/Jenkinsfile-vim-syntax'}
paq {'tfnico/vim-gradle'}
paq {'kevinhwang91/nvim-bqf'}
paq {'rhysd/git-messenger.vim'}
paq {'sk1418/qfgrep'}
-- paq {'ldelossa/litee.nvim'}
-- paq {'ldelossa/litee-calltree.nvim'}
-- paq {'ldelossa/litee-symboltree.nvim'}
-- paq {'ldelossa/litee-filetree.nvim'}
-- paq {'ldelossa/litee-bookmarks.nvim'}
-- paq {'kyazdani42/nvim-web-devicons'}
-- paq {'glepnir/indent-guides.nvim'}
paq {'preservim/vim-indent-guides'}
-- paq {'fatih/vim-go'}
-- paq {'SirVer/ultisnips'}
paq {'honza/vim-snippets'}
paq {'dcampos/nvim-snippy'}
-- paq {'mfussenegger/nvim-dap'}
-- paq {'williamboman/mason.nvim'}
-- paq {'williamboman/mason-lspconfig.nvim'}
paq {'simrat39/rust-tools.nvim'}
paq {'hrsh7th/cmp-buffer'}
paq {'hrsh7th/cmp-nvim-lsp'}
paq {'hrsh7th/cmp-nvim-lsp-signature-help'}
paq {'hrsh7th/cmp-nvim-lua'}
paq {'hrsh7th/cmp-path'}
paq {'hrsh7th/cmp-vsnip'}
paq {'hrsh7th/nvim-cmp'}
paq {'hrsh7th/vim-vsnip'}
paq {'LunarVim/bigfile.nvim'}
-- paq {'mfussenegger/nvim-jdtls'}
