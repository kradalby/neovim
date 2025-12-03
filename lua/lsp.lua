local capabilities = require('cmp_nvim_lsp').default_capabilities()
local min = { capabilities = capabilities }

local capSnippets = require('cmp_nvim_lsp').default_capabilities()
capSnippets.textDocument.completion.completionItem.snippetSupport = true

require('lspsaga').setup({
  request_timeout = 5000,
  finder = {
    jump_to = 'p',
    edit = { "o", "<CR>" },
    vsplit = "v",
    split = "i",
    tabe = "t",
    quit = { "q", "<ESC>" },
  },
  definition = {
    edit = "<C-c>o",
    vsplit = "v",
    split = "<C-c>i",
    tabe = "t",
    quit = "q",
    close = "<Esc>",
  },
})

local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

null_ls.setup(
  {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      if client:supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end,
    sources = {
      null_ls.builtins.code_actions.eslint_d,
      null_ls.builtins.code_actions.shellcheck,
      null_ls.builtins.code_actions.statix,
      null_ls.builtins.completion.spell,
      null_ls.builtins.diagnostics.editorconfig_checker.with(
        {
          args = { "-disable-indentation", "-no-color", "$FILENAME" },
        }
      ),
      null_ls.builtins.diagnostics.actionlint,
      null_ls.builtins.diagnostics.buf,
      null_ls.builtins.diagnostics.commitlint,
      null_ls.builtins.diagnostics.curlylint,
      null_ls.builtins.diagnostics.deadnix,
      null_ls.builtins.diagnostics.djlint,
      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.diagnostics.fish,
      null_ls.builtins.diagnostics.flake8,
      null_ls.builtins.diagnostics.gitlint,
      null_ls.builtins.diagnostics.hadolint,
      null_ls.builtins.diagnostics.mypy,
      null_ls.builtins.diagnostics.pylama,
      null_ls.builtins.diagnostics.shellcheck,
      null_ls.builtins.diagnostics.staticcheck,
      null_ls.builtins.diagnostics.statix,
      null_ls.builtins.diagnostics.stylelint,
      null_ls.builtins.diagnostics.tidy,
      null_ls.builtins.diagnostics.vale,
      null_ls.builtins.diagnostics.write_good,
      null_ls.builtins.diagnostics.yamllint,
      null_ls.builtins.formatting.alejandra,
      null_ls.builtins.formatting.beautysh,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.buf,
      null_ls.builtins.formatting.cbfmt,
      null_ls.builtins.formatting.clang_format,
      null_ls.builtins.formatting.djlint,
      null_ls.builtins.formatting.eslint_d,
      null_ls.builtins.formatting.fish_indent,
      null_ls.builtins.formatting.goimports.with({
        condition = function(utils)
          -- Try to detect if we are in a tailscale repo
          return utils.root_has_file({ "go.toolchain.rev" })
        end,
      }),
      null_ls.builtins.formatting.golines.with({
        condition = function(utils)
          return not utils.root_has_file({ "go.toolchain.rev" })
        end,
      }),
      null_ls.builtins.formatting.isort,
      null_ls.builtins.formatting.jq,
      null_ls.builtins.formatting.tidy,
      null_ls.builtins.formatting.prettier_d_slim,
      null_ls.builtins.formatting.shellharden,
      null_ls.builtins.formatting.shfmt,
      null_ls.builtins.formatting.stylelint,
      null_ls.builtins.formatting.swiftformat,
      -- null_ls.builtins.formatting.terraform_fmt, -- Covered by LSP?
      null_ls.builtins.formatting.trim_newlines,
      null_ls.builtins.formatting.packer,
      null_ls.builtins.hover.dictionary
    }
  }
)

vim.lsp.config('jsonls', {
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
    },
  },
})

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
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
  capabilities = capabilities,
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
  capabilities = capabilities,
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
  capabilities = capabilities,
  filetypes = { "yaml", "yaml.ansible", "ansible" },
  root_markers = { "requirements.yaml", "inventory" },
})

vim.lsp.config('nil_ls', min)
vim.lsp.config('nixd', {
  -- Disable formatting as we want to use Alejandra from
  -- null-ls instead.
  capabilities = capabilities,
})
vim.lsp.config('elmls', min)
vim.lsp.config('terraformls', min)
vim.lsp.config('buf_ls', min)
vim.lsp.config('dhall_lsp_server', min)
vim.lsp.config('golangci_lint_ls', min)
vim.lsp.config('sourcekit', min)
vim.lsp.config('ts_ls', min)
vim.lsp.config('pyright', min)
vim.lsp.config('cssls', {
  capabilities = capSnippets,
})
vim.lsp.config('html', {
  capabilities = capSnippets,
})
vim.lsp.config('tailwindcss', {
  -- Disable formatting as we want to use Alejandra from
  -- null-ls instead.
  capabilities = capabilities,
  filetypes = {
    "go"
  },
  settings = {
    tailwindCSS = {
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        recommendedVariantOrder = "warning",
        unusedClass = "warning",
      },
      experimental = {
        classRegex = {
          'a.Class: "([^"]*)"',
        },
      },
      validate = true,
    },
  },
})

vim.lsp.config('rust_analyzer', min)

-- Enable all configured LSP servers
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
