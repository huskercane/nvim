-- config/lazy.lua

local platform = require("config.platform")

local function is_git_repo()
    vim.fn.system({ "git", "-C", vim.fn.getcwd(), "rev-parse", "--is-inside-work-tree" })
    return vim.v.shell_error == 0
end

local function path_is_under(path, root)
    path = vim.fs.normalize(path or ''):lower()
    root = vim.fs.normalize(root):lower()
    return path == root or path:sub(1, #root + 1) == root .. '/'
end

local function is_ninjarmm_context()
    local file = vim.fn.expand('%:p')
    return path_is_under(file, 'D:/server/ninjarmm')
        or path_is_under(vim.fn.getcwd(), 'D:/server/ninjarmm')
end

local function has_java_project_marker()
    local markers = { 'pom.xml', 'build.gradle', 'build.gradle.kts' }
    local start = vim.fn.expand('%:p')
    if start == '' then
        start = vim.fn.getcwd()
    end

    local root = vim.fs.root(start, markers)
    if root then
        return true
    end

    local cwd = vim.fn.getcwd()
    return vim.fn.filereadable(cwd .. '/pom.xml') == 1
        or vim.fn.filereadable(cwd .. '/build.gradle') == 1
        or vim.fn.filereadable(cwd .. '/build.gradle.kts') == 1
end

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
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- Enable syntax highlighting
                highlight = {
                    enable = true,
                    disable = { "markdown" },
                    additional_vim_regex_highlighting = false,
                },
                -- Enable indentation
                indent = {
                    enable = true,
                },
                -- Enable incremental selection
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
            })
        end,
    },

    -- Completion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/vim-vsnip",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/cmp-cmdline",

    -- Snippets: pre-built collection for many languages
    {
        "rafamadriz/friendly-snippets",
        config = function()
            -- vsnip auto-detects friendly-snippets if installed
        end,
    },

    -- LSP & Tools
    "neovim/nvim-lspconfig",
    "ray-x/lsp_signature.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Git (only in git repos)
    {
        "tpope/vim-fugitive",
        cond = is_git_repo,
    },
    {
        "airblade/vim-gitgutter",
        cond = is_git_repo,
    },
    {
        "rhysd/git-messenger.vim",
        cond = is_git_repo,
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
            quickfile = { enabled = true, exclude = { "markdown" } },
            scope = {
                enabled = true,
                filter = function(buf)
                    return vim.bo[buf].buftype == ""
                        and vim.bo[buf].filetype ~= "markdown"
                        and vim.b[buf].snacks_scope ~= false
                        and vim.g.snacks_scope ~= false
                end,
            },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
        },
    },
    -- uv
    {
        "benomahony/uv.nvim",
        -- Optional filetype to lazy load when you open a python file
        ft = { "python", "toml" },
        -- Optional dependency, but recommended:
        dependencies = {
            "folke/snacks.nvim",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            picker_integration = true,
        },
    },
    -- gradle
    {
        "oclay1st/gradle.nvim",
        cmd = { "Gradle", "GradleExec", "GradleInit", "GradleFavorites" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim"
        },
        opts = {
            gradle_executable = platform.gradle_executable
        }, -- options, see default configuration
        keys = {
            { '<leader>G', desc = '+Gradle' ,  mode = { 'n', 'v' } },
            { '<leader>Gg', '<cmd>Gradle<cr>', desc = 'Gradle Projects' },
            { '<leader>Gf', '<cmd>GradleFavorites<cr>', desc = 'Gradle Favorite Commands' }
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

    --java-helper : for stacktrace navigation
    {
        'NickJAllen/java-helpers.nvim',
        cmd = {
            'JavaHelpersNewFile',
            'JavaHelpersPickStackTraceLine',
            'JavaHelpersPickStackTrace',
            'JavaHelpersGoToStackTraceLine',
            'JavaHelpersGoUpStackTrace',
            'JavaHelpersGoDownStackTrace',
            'JavaHelpersGoToBottomOfStackTrace',
            'JavaHelpersGoToTopOfStackTrace',
            'JavaHelpersGoToNextStackTrace',
            'JavaHelpersGoToPrevStackTrace',
            'JavaHelpersSendStackTraceToQuickfix',
            'JavaHelpersDeobfuscate',
            'JavaHelpersSelectObfuscationFile',
            'JavaHelpersForgetObfuscationFile',
        },

        ---@type JavaHelpers.Config
        opts = {
            new_file = {
                ---Each template has a name and some template source code.
                ---${package_decl} and ${name} will be replaced with the package declaration and name for the Java type being created.
                ---If ${pos} is provided then the cursor will be positioned there ready to type.
                templates = {},

                ---Defines patters to recognize Java source directories in order to determine the package name.
                java_source_dirs = { 'src/main/java', 'src/test/java', 'src' },

                ---If true then newly created Java files will be formatted
                should_format = true,
            },

            stack_trace = {
                --Command that is used to deobfuscate stack traces
                deobfuscate_command = 'retrace',

                --Directory that will be used to select an obfuscation mapping file, if nil or empty the current directory will be used
                obfuscation_mappings_dir = vim.uv.os_homedir() .. '/.obfuscation',
            },
        },
        keys = {
            -- New file creation
            { '<leader>jn', ':JavaHelpersNewFile<cr>', desc = 'New Java Type' },
            { '<leader>jc', ':JavaHelpersNewFile Class<cr>', desc = 'New Java Class' },
            { '<leader>ji', ':JavaHelpersNewFile Interface<cr>', desc = 'New Java Interface' },
            { '<leader>ja', ':JavaHelpersNewFile Abstract Class<cr>', desc = 'New Abstract Java Class' },
            { '<leader>jr', ':JavaHelpersNewFile Record<cr>', desc = 'New Java Record' },
            { '<leader>je', ':JavaHelpersNewFile Enum<cr>', desc = 'New Java Enum' },

            -- Stack trace navigation
            { '<leader>jg', ':JavaHelpersGoToStackTraceLine<cr>', desc = 'Go to Java stack trace line' },
            { '<leader>jG', ':JavaHelpersGoToStackTraceLine +<cr>', desc = 'Go to Java stack trace line on Clipboard' },
            { '<leader>jp', ':JavaHelpersPickStackTraceLine<cr>', desc = 'Pick Java stack trace line' },
            { '<leader>jP', ':JavaHelpersPickStackTraceLine +<cr>', desc = 'Pick Java stack trace line from Clipboard' },
            { '<leader>js', ':JavaHelpersPickStackTrace<cr>', desc = 'Pick Java stack trace in current file' },
            { '[j', ':JavaHelpersGoUpStackTrace<cr>', desc = 'Go up Java stack trace' },
            { ']j', ':JavaHelpersGoDownStackTrace<cr>', desc = 'Go down Java stack trace' },
            { '[J', ':JavaHelpersGoToPrevStackTrace<cr>', desc = 'Go to previous Java stack trace' },
            { ']J', ':JavaHelpersGoToNextStackTrace<cr>', desc = 'Go to next Java stack trace' },
            { '<leader>jt', ':JavaHelpersGoToTopOfStackTrace<cr>', desc = 'Go to top of Java stack trace' },
            { '<leader>jb', ':JavaHelpersGoToBottomOfStackTrace<cr>', desc = 'Go to bottom of Java stack trace' },
            { '<leader>jq', ':JavaHelpersSendStackTraceToQuickfix<cr>', desc = 'Send Java stack trace to quickfix list' },
            { '<leader>jd', ':JavaHelpersDeobfuscate<cr>', desc = 'Deofuscate Java stack trace' },
            { '<leader>jD', ':JavaHelpersDeobfuscate +<cr>', desc = 'Deofuscate Java stack trace on Clipboard' },
            { '<leader>jo', ':JavaHelpersSelectObfuscationFile<cr>', desc = 'Select obfuscation file' },
        },
        dependencies = {
            'nvim-lua/plenary.nvim',

            -- This is only needed if you want to use the JavaHelpersPickStackTraceLine or JavaHelpersSelectObfuscationFile commands (but highly recommended)
            'folke/snacks.nvim',
        },
    }
}
