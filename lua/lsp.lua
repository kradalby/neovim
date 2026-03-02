vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
    },
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      format = {
        enable = true,
      },
      hint = {
        enable = true,
        arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
        await = true,
        paramName = "Disable",  -- "All", "Literal", "Disable"
        paramType = false,
        semicolon = "Disable",  -- "All", "SameLine", "Disable"
        setType = true,
      },
      diagnostics = {
        globals = { "P" },
      },
    },
  },
})

vim.lsp.config('gopls', {
  filetypes = { "go", "gomod", "gotexttmpl", "gohtmltmpl" },
  settings = {
    gopls = {
      gofumpt = false,
      staticcheck = true,
      templateExtensions = { "tmpl", "gotmpl", "tpl" },
    },
  }
})

vim.lsp.config('yamlls', {
  filetypes = {
    "yaml", "yaml.ansible", "ansible"
  },
  settings = {
    yaml = {
      hover = true,
      completion = true,
      validate = true,
      schemas = require("schemastore").json.schemas(),
    },
  },
})

vim.lsp.config('ansiblels', {
  filetypes = { "yaml", "yaml.ansible", "ansible" },
  root_markers = { "requirements.yaml", "inventory" },
})

vim.lsp.config('nixd', {})

vim.lsp.enable({
  'jsonls',
  'lua_ls',
  'gopls',
  'yamlls',
  'ansiblels',
  'nil_ls',
  'nixd',
  'elmls',
  'terraformls',
  'buf_ls',
  'dhall_lsp_server',
  'golangci_lint_ls',
  'sourcekit',
  'ts_ls',
  'pyright',
  'cssls',
  'html',
  'tailwindcss',
  'rust_analyzer',
})
