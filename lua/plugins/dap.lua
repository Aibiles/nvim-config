return {
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        config = function()
            -- 加载 DAP 配置（适配器、调试配置等）
            require "configs.dap"
        end,
    },
    {
        "nvim-neotest/nvim-nio",
    },
    {
        "rcarriga/nvim-dap-ui",
        lazy = false,
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require "configs.dap-ui"
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            require "configs.dap-python"
        end,
    },

    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = false,
        dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-dap-virtual-text").setup({
                virt_text_pos = "eol", -- 显示在行尾（默认 inline 显示在行内）
            })
            -- vim.api.nvim_set_hl(0, "NvimDapVirtualText", { fg = "#ffcb6b", bold = true })
            vim.api.nvim_set_hl(0, "NvimDapVirtualTextChanged", { fg = "#ffcb6b", bold = true })
        end,
    },
}
