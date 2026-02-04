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

    -- Large file handling
    {
        "LunarVim/bigfile.nvim",
        config = function()
            require("bigfile").setup({
                filesize = 2, -- size in MB
                features = {  -- features to disable
                    "indent_blankline",
                    "illuminate",
                    "lsp",
                    "treesitter",
                    "syntax",
                    "matchparen",
                    "vimopts",
                    "filetype",
                },
            })
        end,
    },

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

    -- Git (only in git repos)
    {
        "tpope/vim-fugitive",
        cond = function()
            return vim.fn.isdirectory(vim.fn.getcwd() .. '/.git') == 1
        end,
    },
    {
        "airblade/vim-gitgutter",
        cond = function()
            return vim.fn.isdirectory(vim.fn.getcwd() .. '/.git') == 1
        end,
    },
    {
        "rhysd/git-messenger.vim",
        cond = function()
            return vim.fn.isdirectory(vim.fn.getcwd() .. '/.git') == 1
        end,
    },

    -- Java (only in Java projects)
    {
        "nvim-java/nvim-java",
        cond = function()
            return vim.fn.filereadable(vim.fn.getcwd() .. '/pom.xml') == 1
            or vim.fn.filereadable(vim.fn.getcwd() .. '/build.gradle') == 1
            or vim.fn.filereadable(vim.fn.getcwd() .. '/build.gradle.kts') == 1
        end,
    },
    {
        "JavaHello/spring-boot.nvim",
        cond = function()
            return vim.fn.filereadable(vim.fn.getcwd() .. '/pom.xml') == 1
            or vim.fn.filereadable(vim.fn.getcwd() .. '/build.gradle') == 1
            or vim.fn.filereadable(vim.fn.getcwd() .. '/build.gradle.kts') == 1
        end,
    },

    -- Debugging
    "mfussenegger/nvim-dap",

    -- eslint (only in JS/TS projects)
    {
        'esmuellert/nvim-eslint',
        cond = function()
            return vim.fn.filereadable(vim.fn.getcwd() .. '/package.json') == 1
            or vim.fn.glob(vim.fn.getcwd() .. '/.eslintrc*') ~= ''
        end,
        config = function()
            require('nvim-eslint').setup({})
        end,
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            explorer = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
        },
    },
    -- uv
    {
        "benomahony/uv.nvim",
        -- Optional filetype to lazy load when you open a python file
        ft = { "python" },
        -- Optional dependency, but recommended:
        dependencies = {
            "folke/snacks.nvim",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            picker_integration = true,
        },
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
            vim.api.nvim_set_keymap('n',
                '<leader>npm',
                ':Npm ',
                { noremap = true, silent = false }
            )
        end,
    },

}

