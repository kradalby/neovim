local dap = require("dap")
local dapui = require("dapui")
local tse = require('telescope').extensions

dapui.setup()
require("dap-go").setup({
        dap_configurations = {
            {
            name =  "Debug tailcontrol",
            type =  "go",
            request =  "launch",
            -- mode =  "exec",
            program = vim.fn.getcwd() .. "/cmd/tailcontrol/",
            args =  {
                "-dev",
                "-confdir=./ignore",
                "--addr=:31544",
                "--url=http://localhost:31544"
            },
        },
        {
            name =  "Debug tailcontrol test",
            type =  "go",
            request =  "launch",
            mode =  "exec",
            -- program =  "${fileDirname}/__debug_bin",
            -- cwd =  "${fileDirname}",
        }
        },
    })
require("nvim-dap-virtual-text").setup()

vim.keymap.set("n", "<leader>dc", dap.continue, {})
vim.keymap.set("n", "<leader>ds", dap.step_over, {})
vim.keymap.set("n", "<leader>dsi", dap.step_into, {})
vim.keymap.set("n", "<leader>dso", dap.step_out, {})
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {})
vim.keymap.set("n", "<leader>dui", dapui.toggle, {})
vim.keymap.set("n", "<leader>dro", dap.repl.open, {})
vim.keymap.set("n", "<leader>dcc", tse.dap.commands, {})
vim.keymap.set("n", "<leader>dlb", tse.dap.list_breakpoints, {})
vim.keymap.set("n", "<leader>dv", tse.dap.variables, {})
vim.keymap.set("n", "<leader>df", tse.dap.frames, {})
