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
            {
                name =  "Debug test",
                type =  "go",
                request =  "launch",
                mode = "test",
                program = "${file}",
            }
        },
        delve = {
            port = "${port}",
            args = {"--check-go-version=false"},
        },
    })
require("nvim-dap-virtual-text").setup()
