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

-- Mason (optional)
pcall(function()
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "ruff", "bashls", "dockerls" },
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

if is_java_project() then
  table.insert(servers, "jdtls")
end

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
    init_options = { settings = {} },
  }
end

-- Enable all servers
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

-- Java (nvim-java manages jdtls)
if is_java_project() then
  pcall(function() require("java").setup({}) end)
end

