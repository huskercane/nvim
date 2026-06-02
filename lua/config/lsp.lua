-- config/lsp.lua — Neovim 0.11+ native LSP API

local platform = require("config.platform")

-- Helper functions for conditional LSP loading
local function is_python_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.filereadable(cwd .. '/pyproject.toml') == 1
    or vim.fn.filereadable(cwd .. '/setup.py') == 1
    or vim.fn.filereadable(cwd .. '/requirements.txt') == 1
    or vim.fn.glob(cwd .. '/*.py') ~= ''
end

local function is_docker_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.filereadable(cwd .. '/Dockerfile') == 1
    or vim.fn.filereadable(cwd .. '/docker-compose.yml') == 1
    or vim.fn.filereadable(cwd .. '/docker-compose.yaml') == 1
end

local function is_java_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.filereadable(cwd .. '/pom.xml') == 1
    or vim.fn.filereadable(cwd .. '/build.gradle') == 1
    or vim.fn.filereadable(cwd .. '/build.gradle.kts') == 1
end

local function is_kotlin_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.glob(cwd .. '/*.kt') ~= ''
    or vim.fn.glob(cwd .. '/*.kts') ~= ''
    or vim.fn.glob(cwd .. '/src/**/*.kt') ~= ''
    or vim.fn.filereadable(cwd .. '/build.gradle.kts') == 1
end

local function is_js_ts_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.filereadable(cwd .. '/package.json') == 1
    or vim.fn.filereadable(cwd .. '/tsconfig.json') == 1
    or vim.fn.glob(cwd .. '/.eslintrc*') ~= ''
end

local function is_go_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.filereadable(cwd .. '/go.mod') == 1
    or vim.fn.glob(cwd .. '/*.go') ~= ''
end

local function is_rust_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.filereadable(cwd .. '/Cargo.toml') == 1
end

local function is_ansible_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.isdirectory(cwd .. '/roles') == 1
    or vim.fn.isdirectory(cwd .. '/playbooks') == 1
    or vim.fn.filereadable(cwd .. '/ansible.cfg') == 1
    or vim.fn.glob(cwd .. '/*playbook*.yml') ~= ''
    or vim.fn.glob(cwd .. '/*playbook*.yaml') ~= ''
end

-- Mason (optional)
pcall(function()
  require("mason").setup()
  require("mason-lspconfig").setup({
    automatic_enable = {
      exclude = { "jdtls" },
    },
    -- Skip any server this machine opted out of via local.lua.
    ensure_installed = vim.tbl_filter(function(s)
      return not platform.disabled("server", s)
    end, {
      "pyright", "ruff", "bashls", "dockerls",
      "ts_ls", "gopls", "rust_analyzer", "lua_ls",
      "kotlin_language_server",
      "ansiblels", "html", "cssls", "jsonls", "yamlls",
    }),
  })
end)

-- Optional helpers
pcall(function() require("lsp_signature").setup({}) end)

-- Capabilities (cmp_nvim_lsp optional)
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end)

local function set_lsp_keymaps(bufnr)
  local map = function(m, lhs, rhs)
    vim.keymap.set(m, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
  end
  map("n", "gd", vim.lsp.buf.definition)
  map("n", "gD", vim.lsp.buf.declaration)
  map("n", "K", vim.lsp.buf.hover)
  map("n", "gi", vim.lsp.buf.implementation)
  map("n", "<leader>li", vim.lsp.buf.implementation)
  map("n", "<C-k>", vim.lsp.buf.signature_help)
  map("n", "<space>rn", vim.lsp.buf.rename)
  map("n", "<space>ca", vim.lsp.buf.code_action)
  map({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action)
  map("n", "gr", vim.lsp.buf.references)
  map("n", "<space>e", vim.diagnostic.open_float)
  map("n", "[d", vim.diagnostic.goto_prev)
  map("n", "]d", vim.diagnostic.goto_next)
  map("n", "<space>q", vim.diagnostic.setloclist)
  map("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end)
end

-- on_attach keymaps
local on_attach = function(_, bufnr)
  set_lsp_keymaps(bufnr)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
  callback = function(args)
    set_lsp_keymaps(args.buf)
  end,
  desc = "Set LSP keymaps for every attached client",
})

-- Build server list conditionally
local servers = { "bashls" } -- bashls always enabled

if is_python_project() then
  table.insert(servers, "pyright")
  table.insert(servers, "ruff")
end

if is_docker_project() then
  table.insert(servers, "dockerls")
end

if is_js_ts_project() then
  table.insert(servers, "ts_ls")
  table.insert(servers, "cssls")
  table.insert(servers, "html")
end

if is_go_project() then
  table.insert(servers, "gopls")
end

if is_rust_project() then
  table.insert(servers, "rust_analyzer")
end

if is_kotlin_project() then
  table.insert(servers, "kotlin_language_server")
end

if is_ansible_project() then
  table.insert(servers, "ansiblels")
end

-- Always useful for config files
table.insert(servers, "jsonls")
table.insert(servers, "yamlls")
table.insert(servers, "lua_ls")

-- Base config for all servers
for _, server in ipairs(servers) do
  vim.lsp.config[server] = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Pyright: disable organize imports (let ruff handle it)
if is_python_project() then
  vim.lsp.config.pyright = {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      pyright = { disableOrganizeImports = true },
      python = {
        analysis = {
          diagnosticSeverityOverrides = { reportUnusedImport = "none" },
        },
      },
    },
  }

  -- Ruff: minimal config
  vim.lsp.config.ruff = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- lua_ls: suppress "undefined global vim" warning
vim.lsp.config.lua_ls = {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

if is_kotlin_project() then
  vim.lsp.config.kotlin_language_server = {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd_env = {
      KOTLIN_LANGUAGE_SERVER_OPTS = "-Xms128m -Xmx2G -XX:MaxMetaspaceSize=512m",
    },
  }
end

-- Drop servers this machine opted out of (e.g. no Go/Rust toolchain here).
servers = vim.tbl_filter(function(s)
  return not platform.disabled("server", s)
end, servers)

-- Enable all non-Java servers. Java is started by the plain jdtls block below.
vim.lsp.enable(servers)

-- Disable ruff hover (let pyright handle it) - only for Python projects
if is_python_project() then
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_disable_ruff_hover", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
      end
    end,
    desc = "Disable hover from Ruff",
  })
end

-- Plain Java LSP. Keep this independent of Mason's jdtls.cmd, because the
-- Windows Mason wrapper starts through Python.
do
  local java_home = platform.java_home
  local java_exe = java_home
    and (java_home .. platform.sep .. "bin" .. platform.sep .. "java" .. platform.exe)
    or "java"
  local jdtls_root = vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/packages/jdtls")
  local function java_project_root(bufnr)
    local file = vim.api.nvim_buf_get_name(bufnr)
    local start = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()

    for dir in vim.fs.parents(start) do
      if vim.fn.filereadable(dir .. "/pom.xml") == 1
        or vim.fn.filereadable(dir .. "/build.gradle") == 1
        or vim.fn.filereadable(dir .. "/build.gradle.kts") == 1 then
        return dir
      end
    end

    return vim.fn.getcwd()
  end

  local function jdtls_workspace(root_dir)
    local workspace_name = vim.fs.normalize(root_dir):gsub("[:/\\]+", "_")
    local workspace_dir = vim.fs.normalize(vim.fn.stdpath("data") .. "/jdtls/workspaces/" .. workspace_name)
    pcall(vim.fn.mkdir, workspace_dir, "p")
    return workspace_dir
  end

  local function jdtls_cmd(root_dir)
    local launcher = vim.fn.glob(jdtls_root .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    if launcher == "" then
      vim.notify("jdtls launcher jar not found under " .. jdtls_root, vim.log.levels.ERROR)
      return nil
    end

    return {
      java_exe,
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dosgi.checkConfiguration=true",
      "-Xms256m",
      "-Xmx6G",
      "-XX:MaxMetaspaceSize=512m",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-jar",
      launcher,
      "-configuration",
      jdtls_root .. "/" .. platform.jdtls_config_dir,
      "-data",
      jdtls_workspace(root_dir),
    }
  end

  function _G.start_java_lsp(bufnr)
    bufnr = bufnr or 0
    if vim.bo[bufnr].filetype ~= "java" then
      vim.notify("Current buffer is not a Java file", vim.log.levels.WARN)
      return
    end

    if vim.fn.executable(java_exe) ~= 1 then
      vim.notify(
        "Java not found (" .. java_exe .. "). Set java_home in lua/config/local.lua.",
        vim.log.levels.ERROR
      )
      return
    end

    local root_dir = java_project_root(bufnr)
    local cmd = jdtls_cmd(root_dir)
    if not cmd then
      return
    end

    vim.g.java_lsp_last_cmd = cmd
    vim.g.java_lsp_last_root = root_dir

    vim.lsp.start({
      name = "jdtls",
      cmd = cmd,
      root_dir = root_dir,
      filetypes = { "java" },
      capabilities = capabilities,
      on_attach = on_attach,
      cmd_env = java_home and {
        JAVA_HOME = java_home,
        PATH = java_home .. platform.sep .. "bin" .. platform.pathsep .. (vim.env.PATH or ""),
      } or nil,
      settings = {
        java = {
          import = java_home and {
            gradle = { java = { home = java_home } },
          } or nil,
          configuration = platform.java_runtimes and {
            runtimes = platform.java_runtimes,
          } or nil,
        },
      },
    }, {
      bufnr = bufnr,
      reuse_client = function(client)
        return client.name == "jdtls" and client.config.root_dir == root_dir
      end,
    })
  end

  vim.api.nvim_create_user_command("JavaLspStatus", function()
    print("java_lsp_last_root = " .. tostring(vim.g.java_lsp_last_root))
    print("java_lsp_last_cmd = " .. vim.inspect(vim.g.java_lsp_last_cmd))
    print("jdtls clients = " .. #vim.lsp.get_clients({ name = "jdtls" }))
  end, {})

  -- jdtls is intentionally NOT auto-started. Use :JavaLspStart (or <leader>lj)
  -- to launch it on demand in a Java project.
  vim.api.nvim_create_user_command("JavaLspStart", function()
    _G.start_java_lsp(0)
  end, {})
end
