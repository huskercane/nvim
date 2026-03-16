-- config/lsp.lua — Neovim 0.11+ native LSP API

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
    ensure_installed = {
      "pyright", "ruff", "bashls", "dockerls",
      "ts_ls", "gopls", "rust_analyzer", "lua_ls",
      "ansiblels", "html", "cssls", "jsonls", "yamlls",
    },
  })
end)

-- Optional helpers
pcall(function() require("lsp_signature").setup({}) end)

-- Capabilities (cmp_nvim_lsp optional)
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end)

-- on_attach keymaps
local on_attach = function(_, bufnr)
  local map = function(m, lhs, rhs)
    vim.keymap.set(m, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
  end
  map("n", "gd", vim.lsp.buf.definition)
  map("n", "gD", vim.lsp.buf.declaration)
  map("n", "K", vim.lsp.buf.hover)
  map("n", "gi", vim.lsp.buf.implementation)
  map("n", "<C-k>", vim.lsp.buf.signature_help)
  map("n", "<space>rn", vim.lsp.buf.rename)
  map("n", "<space>ca", vim.lsp.buf.code_action)
  map("n", "gr", vim.lsp.buf.references)
  map("n", "<space>e", vim.diagnostic.open_float)
  map("n", "[d", vim.diagnostic.goto_prev)
  map("n", "]d", vim.diagnostic.goto_next)
  map("n", "<space>q", vim.diagnostic.setloclist)
  map("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end)
end

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

-- Enable all servers (jdtls excluded — start on demand with <leader>lj)
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

-- Java (nvim-java manages jdtls) — no longer auto-starts
-- Use <leader>lj to start jdtls on demand
