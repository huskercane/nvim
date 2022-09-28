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
paq {'ldelossa/litee.nvim'}
paq {'ldelossa/litee-calltree.nvim'}
paq {'ldelossa/litee-symboltree.nvim'}
paq {'ldelossa/litee-filetree.nvim'}
paq {'ldelossa/litee-bookmarks.nvim'}
paq {'kyazdani42/nvim-web-devicons'}
paq {'glepnir/indent-guides.nvim'}
paq {'fatih/vim-go'}
paq {'SirVer/ultisnips'}
paq {'honza/vim-snippets'}
