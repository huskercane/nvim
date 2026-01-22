-- config/lsp.lua — zero 'require("lspconfig")', fully compatible with 0.11+

-- Mason (optional but nice)
pcall(function()
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "bashls", "dockerls" },
  })
end)

-- Optional helpers
pcall(function() require("lsp_signature").setup({}) end)

-- Capabilities (cmp_nvim_lsp optional)
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end)

-- on_attach
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

-- Tiny root detector (no lspconfig.util)
local function root_pattern(markers)
  return function(startpath)
    local found = vim.fs.find(markers, { upward = true, path = startpath })
    if #found > 0 then
      return vim.fs.dirname(found[1])
    end
    return vim.fn.getcwd()
  end
end

-- Server definitions WITHOUT lspconfig
local servers = {
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = root_pattern({
      "pyproject.toml", "setup.py", "setup.cfg",
      "requirements.txt", "Pipfile", ".git",
    }),
    settings = {},
  },

  bashls = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh" }, -- keep to 'sh'; zsh often works but is unofficial
    root_dir = root_pattern({ ".git", ".bashrc", ".bash_profile" }),
    settings = {},
  },

  dockerls = {
    cmd = { "docker-langserver", "--stdio" },
    filetypes = { "dockerfile" },
    root_dir = root_pattern({ "Dockerfile", ".git" }),
    settings = {},
  },

  -- NOTE: jdtls is special; usually managed by nvim-java.
  -- If you really want to start it here, uncomment and ensure 'jdtls' is in PATH.
  -- jdtls = {
  --   cmd = { "jdtls" },
  --   filetypes = { "java" },
  --   root_dir = root_pattern({ "gradlew", "mvnw", ".git" }),
  --   settings = {},
  -- },
}

-- Start each server on matching FileType
for name, s in pairs(servers) do
  local group = vim.api.nvim_create_augroup("lsp-auto-" .. name, { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = s.filetypes or "*",
    desc = "Start " .. name .. " via vim.lsp.start",
    callback = function(args)
      local buf = args.buf
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname == "" then return end

      local root_dir = s.root_dir and s.root_dir(bufname) or vim.fn.getcwd()

      -- Avoid duplicate clients for this buffer
      local existing = vim.lsp.get_clients({ name = name, bufnr = buf })
      if #existing > 0 then return end

      vim.lsp.start({
        name = name,
        cmd = s.cmd,
        cmd_env = s.cmd_env,
        root_dir = root_dir,
        settings = s.settings,
        init_options = s.init_options,
        single_file_support = s.single_file_support,
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = s.handlers,
      })
    end,
  })
end

-- If you use nvim-java, let it manage jdtls itself:
pcall(function() require("java").setup({}) end)

