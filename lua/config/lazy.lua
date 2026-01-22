-- config/lazy.lua

return {
  -- Lazy itself
  { "folke/lazy.nvim", version = "*" },

  -- Appearance
  { 
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        -- contrast = "hard", -- or "soft"
        -- transparent_mode = true,
      })
      vim.o.background = "dark" -- or "light"
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  { "lukas-reineke/indent-blankline.nvim" },

  -- Telescope
  { 
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc="Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc="Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc="Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc="Help Tags" },
    },
    config = function()
      require("telescope").setup()
    end,
  },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/vim-vsnip",
  "hrsh7th/cmp-vsnip",

  -- LSP & Tools
  "neovim/nvim-lspconfig",
  "ray-x/lsp_signature.nvim",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  -- Git
  "tpope/vim-fugitive",
  "airblade/vim-gitgutter",
  "rhysd/git-messenger.vim",

  -- Java
  "nvim-java/nvim-java",
  "JavaHello/spring-boot.nvim",

  -- Debugging
  "mfussenegger/nvim-dap",

  -- eslint
  {
      'esmullert/nvim-eslint',
      config = function()
          require('nvim-eslint').setup({})
      end,
  },
  -- npm
  {
      'maxolasersquad/npm-scripts.nvim',
      cond = function()
          return vim.fn.filereadable(vim.fn.getcwd() .. '/package.json') == 1
      end,
      config = function()
          require('npm')
          -- Optional: Add your key mapping here
          vim.api.nvim_set_keymap('n', '<leader>npm', ':Npm', { noremap = true, silent = false })
      end
  },
}

