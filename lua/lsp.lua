local lsp = require 'lspconfig' 

require 'lsp_signature'.on_attach()

-- lsp config
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
on_attach = function(client, bufnr)
    require 'lsp_signature'.on_attach()
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

lsp.pyright.setup{
    on_attach = on_attach
}
lsp.bashls.setup{}
lsp.dockerls.setup{}
-- lsp.jdtls.setup{
--     on_attach = on_attach,
--     flags = {
--         debounce_text_changes = 150,
--     }
-- }
lsp.solargraph.setup {
    on_attach = on_attach
}
lsp.gopls.setup{
    on_attach = on_attach,
    cmd = {"gopls", "serve"},
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
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


-- vim.api.nvim_command('autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 100)')
-- vim.api.nvim_command('autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 100)')
-- vim.api.nvim_command('autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 100)')
-- make your Ctrl+x,Ctrl+o work, add this to your init.vim:
vim.api.nvim_command('autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc')


local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
        '/home/rohits/.sdkman/candidates/java/17.0.5-amzn/bin/java',
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.time=ALL-UNNAMED",
        "--add-opens",
        "java.xml/jdk.xml.internal=ALL-UNNAMED",
        "--add-opens",
        "java.base/sun.security.util=ALL-UNNAMED",
        "--add-opens",
        "ava.base/jdk.internal.util.random=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.security=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.io=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.nio.file=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.nio.charset=ALL-UNNAMED",
        "--add-opens",
        "java.base/jdk.internal.access=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.net=ALL-UNNAMED",
        "--add-opens",
        "java.base/sun.security.x509=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.util.stream=ALL-UNNAMED",
        "--add-opens",
        "java.base/sun.nio.cs=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.util.concurrent=ALL-UNNAMED",
        "--add-opens",
        "java.logging/java.util.logging=ALL-UNNAMED",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dfile.encoding=UTF-8",
        "-DwatchParentProcess=true",
        "-noverify",
        "-Xmx1G",
        "-XX:+UseG1GC",
        "-XX:+UseStringDeduplication",
        "-jar",
        "/home/rohits/work/jdt-language-server-latest/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
        "-configuration",
        "/home/rohits/work/jdt-language-server-latest/config_linux",
        "-data",
        "/home/rohits/work/eclipse/workspaces/cgadmin-ws"
    },

    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
        }
    }
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
-- require('jdtls').setup(config)
-- require('jdtls').start_or_attach(config)
