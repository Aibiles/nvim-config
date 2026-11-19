require "nvchad.autocmds"

-- C/C++ 使用 4 空格缩进（与 clang-format 的 IndentWidth:4 保持一致）
-- NvChad 全局默认是 2 空格，这里仅针对 C/C++ 覆盖
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})
