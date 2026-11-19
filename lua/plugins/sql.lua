return {
    {
        "tpope/vim-dadbod",
        lazy = false,
        -- 纯 vimscript 插件，无需 config；负责 :DB 命令和数据库连接
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod", lazy = true },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        keys = {
            { "<leader>sq", "<cmd>DBUIToggle<CR>", desc = "Toggle DB UI (dadbod)" },
            { "<leader>sf", "<cmd>DB<CR>", desc = "Run SQL query" },
            { "<leader>sf", "<cmd>DB<CR>", mode = "v", desc = "Run selected SQL" },
        },
        config = function()
            require "configs.dadbod-ui"
        end,
    },
    -- SQL 补全由 sqls LSP 提供（见 configs/lspconfig.lua），无需 vim-dadbod-completion
    -- （后者依赖 deno + denops.vim，为保持轻量已省略）
}
