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
      gofumpt = true,
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

vim.lsp.config('nixd', {
  settings = {
    nixd = {
      nixpkgs = {
        -- Use the nixpkgs from the flake in the current directory, falling
        -- back to the system flake registry.
        expr = 'import <nixpkgs> {}',
      },
    },
  },
})

vim.lsp.config('vtsls', {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  settings = {
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
    },
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
    },
  },
})

vim.lsp.config('ruff', {
  -- Ruff handles linting and formatting for Python; disable hover in
  -- favour of pyright which provides richer type information.
  init_options = {
    settings = {
      organizeImports = true,
    },
  },
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = false
  end,
})

vim.lsp.enable({
  'jsonls',
  'lua_ls',
  'gopls',
  'yamlls',
  'nixd',
  'terraformls',
  'vtsls',
  'pyright',
  'ruff',
})
