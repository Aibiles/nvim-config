vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_ui"

-- dadbod 默认连接的数据库 URL（可留空，用 :DB 命令时指定）
-- 示例：
--   sqlite:  sqlite:///path/to/db.sqlite3
--   mysql:   mysql://user:password@host:port/database
--   pgsql:   postgres://user:password@host:port/database
-- vim.g.dadbod_url = ""

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "dbout",      -- :DB 输出 buffer
        "sql", -- SQL 文件
    },
    callback = function()
        vim.opt_local.wrap = false
    end,
})
