require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- ========================================
-- Debug keymaps (nvim-dap)
-- ========================================
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional breakpoint" })
map("n", "<leader>dl", function()
  require("dap").set_breakpoint(nil, nil, vim.fn.input("日志内容 (如 x={x}): "))
end, { desc = "Log point" })
map("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "Continue / Start debug" })
map("n", "<leader>dn", "<cmd>DapStepOver<CR>", { desc = "Step over" })
map("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "Step into" })
map("n", "<leader>do", "<cmd>DapStepOut<CR>", { desc = "Step out" })
map("n", "<leader>dr", "<cmd>DapToggleRepl<CR>", { desc = "Toggle REPL" })
map("n", "<leader>dt", "<cmd>DapTerminate<CR>", { desc = "Terminate debug session" })
map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle DAP UI" })

-- ========================================
-- Debug keymaps — 方向键（调试会话激活时接管方向键）
-- ========================================
-- 非调试时方向键回退为正常光标移动 (hjkl)
local function dap_enabled()
  local ok, session = pcall(function()
    return require("dap").session()
  end)
  return ok and session ~= nil
end

-- expr=true: 返回字符串作为按键执行；无条件时手动 feed
-- Down → step over, 否则 j
map("n", "<Down>", function()
  if dap_enabled() then require("dap").step_over() return "" end
  return "j"
end, { expr = true, desc = "Step over / j" })

-- Right → step into, 否则 l
map("n", "<Right>", function()
  if dap_enabled() then require("dap").step_into() return "" end
  return "l"
end, { expr = true, desc = "Step into / l" })

-- Left → step out, 否则 h
map("n", "<Left>", function()
  if dap_enabled() then require("dap").step_out() return "" end
  return "h"
end, { expr = true, desc = "Step out / h" })

-- Up → restart frame, 否则 k
map("n", "<Up>", function()
  if dap_enabled() then require("dap").restart_frame() return "" end
  return "k"
end, { expr = true, desc = "Restart frame / k" })
