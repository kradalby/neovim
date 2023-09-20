local M = {}

M.luafmt = {
    formatCommand = "luafmt --stdin",
    formatStdin = true
}

M.flake8 = {
    lintCommand = "flake8 --ignore=E501 --stdin-display-name ${INPUT} -",
    lintStdin = true,
    lintIgnoreExitCode = true,
    lintFormats = { "%f:%l:%c: %m" }
}

M.mypy = {
    lintCommand = "mypy --show-column-numbers --ignore-missing-imports",
    lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" }
}

M.shfmt = {
    formatCommand = "shfmt -ci -s -bn",
    formatStdin = true
}

M.yamllint = {
    lintCommand = "yamllint -f parsable -",
    lintStdin = true
}

M.stylelint = {
    lintCommand = "stylelint --stdin --stdin-filename ${INPUT} --formatter compact",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = { "%f: line %l, col %c, %tarning - %m", "%f: line %l, col %c, %trror - %m" },
    formatCommand = "stylelint --fix --stdin --stdin-filename ${INPUT}",
    formatStdin = true
}

M.languages = {
    python = {
        M.flake8,
        M.mypy
    },
    lua = { M.luafmt },
    typescript = { M.stylelint,
    },
    typescriptreact = {
    },
    javascript = {
    },
    javascriptreact = {
    },
    go = {
    },
    sh = {
        M.shfmt,
    },
    yaml = {
        M.yamllint,
    },
    ["yaml.ansible"] = {
        M.yamllint,
    },
    proto = { M.clangfmtproto, M.buf_lint },
}

return M
