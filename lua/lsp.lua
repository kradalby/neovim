require("neodev").setup()
local lspconfig = require "lspconfig"
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
null_ls.setup(
  {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
            vim.lsp.buf.format()
          end,
        })
      end
    end,
    sources = {
      null_ls.builtins.code_actions.eslint_d,
      null_ls.builtins.code_actions.proselint,
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
      null_ls.builtins.diagnostics.proselint,
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
      null_ls.builtins.formatting.golines,
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
      null_ls.builtins.formatting.trim_whitespace,
      null_ls.builtins.formatting.packer,
      null_ls.builtins.hover.dictionary
    }
  }
)

lspconfig.jsonls.setup {
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
    },
  },
}

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      format = {
        enable = true,
      },
      hint = {
        enable = true,
        arrayIndex = "Disable",         -- "Enable", "Auto", "Disable"
        await = true,
        paramName = "Disable",          -- "All", "Literal", "Disable"
        paramType = false,
        semicolon = "Disable",          -- "All", "SameLine", "Disable"
        setType = true,
      },
      diagnostics = {
        globals = { "P" },
      },
    },
  },
})
lspconfig.gopls.setup {
  capabilities = capabilities,
  filetypes = { "go", "gomod", "gotexttmpl", "gohtmltmpl" },
  settings = {
    gopls = {
      gofumpt = false,
      staticcheck = true,
      templateExtensions = { "tmpl", "gotmpl", "tpl" },
    },
  }
}

lspconfig.yamlls.setup {
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
}

lspconfig.ansiblels.setup {
  capabilities = capabilities,
  filetypes = { "yaml", "yaml.ansible", "ansible" },
  root_dir = function(fname)
    return lspconfig.util.root_pattern { "requirements.yaml", "inventory" } (fname)
  end
}

lspconfig.nil_ls.setup(min)
lspconfig.nixd.setup({
  -- Disable formatting as we want to use Alejandra from
  -- null-ls instead.
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
})
lspconfig.elmls.setup(min)
lspconfig.terraformls.setup(min)
lspconfig.bufls.setup(min)
lspconfig.dhall_lsp_server.setup(min)
lspconfig.golangci_lint_ls.setup(min)
lspconfig.sourcekit.setup(min)
lspconfig.tsserver.setup(min)
lspconfig.pyright.setup(min)
lspconfig.cssls.setup({
  capabilities = capSnippets,
})
lspconfig.jsonls.setup({
  capabilities = capSnippets,
})
lspconfig.html.setup({
  capabilities = capSnippets,
})

require("rust-tools").setup {}
