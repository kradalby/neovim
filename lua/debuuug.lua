local dapui = require("dapui")

dapui.setup()
require("dap-go").setup({
        dap_configurations = {
            {
                name =  "Debug tailcontrol",
                type =  "go",
                request =  "launch",
                program = vim.fn.getcwd() .. "/cmd/tailcontrol/",
                args =  {
                    "-dev",
                    "-confdir=./ignore",
                    "--addr=:31544",
                    "--url=http://localhost:31544"
                },
            },
        },
        delve = {
            port = "${port}",
            args = {"--check-go-version=false", "--log", "--log-output=dap"},
        },
    })
require("nvim-dap-virtual-text").setup()
