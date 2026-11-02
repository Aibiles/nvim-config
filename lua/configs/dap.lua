-- nvim-dap configuration for Python and C/C++ debugging
-- Python: pip install debugpy (or yay -S python-debugpy)
-- C/C++:  yay -S codelldb (推荐) 或 pacman -S lldb (提供 lldb-dap)

local dap = require("dap")

-- ========================================
-- 自定义断点图标和颜色
-- ========================================
-- 先定义高亮组颜色（直接调用 API，确保生效）
local breakpoint_colors = {
  DapBreakpoint          = { fg = "#ff3333" }, -- 红色断点
  DapBreakpointCondition = { fg = "#ffaa00" }, -- 橙色条件断点
  DapBreakpointRejected  = { fg = "#555555" }, -- 灰色无效断点
  DapLogPoint            = { fg = "#00aaff" }, -- 蓝色日志点
  DapStopped             = { fg = "#00e000" }, -- 绿色当前行
}

for group, colors in pairs(breakpoint_colors) do
  vim.api.nvim_set_hl(0, group, colors)
end

-- 定义 sign 图标
vim.fn.sign_define("DapBreakpoint", {
  text = "●",
  texthl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})
vim.fn.sign_define("DapBreakpointCondition", {
  text = "◆",
  texthl = "DapBreakpointCondition",
  numhl = "DapBreakpointCondition",
})
vim.fn.sign_define("DapBreakpointRejected", {
  text = "●",
  texthl = "DapBreakpointRejected",
  numhl = "DapBreakpointRejected",
})
vim.fn.sign_define("DapLogPoint", {
  text = "◆",
  texthl = "DapLogPoint",
  numhl = "DapLogPoint",
})
vim.fn.sign_define("DapStopped", {
  text = "→",
  texthl = "DapStopped",
  linehl = "Visual",
  numhl = "DapStopped",
})

-- Python debug adapter (debugpy)
dap.adapters.python = {
  type = "executable",
  command = vim.fn.exepath("python") or "python3",
  args = { "-m", "debugpy.adapter" },
}

-- Python debug configurations
dap.configurations.python = {
  {
    -- 调试当前文件
    type = "python",
    request = "launch",
    name = "Launch current file",
    program = "${file}",
    console = "integratedTerminal",
  },
  {
    -- 调试当前文件（带参数），参数在启动时输入
    type = "python",
    request = "launch",
    name = "Launch with args",
    program = "${file}",
    args = function()
      local args_str = vim.fn.input("Program arguments: ")
      return vim.split(args_str, " ")
    end,
    console = "integratedTerminal",
  },
  {
    -- 附加到远程 debugpy 进程
    type = "python",
    request = "attach",
    name = "Attach to process",
    connect = {
      host = "127.0.0.1",
      port = 5678,
    },
  },
  {
    -- 仅用于单元测试文件
    type = "python",
    request = "launch",
    name = "pytest (current file)",
    module = "pytest",
    args = { "${file}", "-v" },
    console = "integratedTerminal",
  },
}

-- ========================================
-- C/C++ Debugging (codelldb / lldb-dap / gdb)
-- ========================================
-- 三种调试器后端，按需安装其一即可：
--   codelldb:      yay -S codelldb          (LLDB, 功能最全)
--   lldb-dap:      sudo pacman -S lldb      (LLDB ≥ 18, 轻量)
--   gdb:           sudo pacman -S gdb        (GDB ≥ 14 原生支持 DAP)
-- C/C++ 文件调试时会列出所有可用的适配器供选择。

-- 适配器: codelldb
if vim.fn.exepath("codelldb") ~= "" then
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = "codelldb",
      args = { "--port", "${port}" },
    },
  }
end

-- 适配器: lldb-dap (LLDB ≥ 18 起 lldb-vscode 重命名为 lldb-dap)
-- 注意: LLDB 23.x 的 stdio 模式不响应握手，需用 --connection listen:// 套接字模式
-- if vim.fn.exepath("lldb-dap") ~= "" then
--   dap.adapters.lldb = {
--     type = "server",
--     host = "127.0.0.1",
--     port = "${port}",
--     executable = {
--       command = "lldb-dap",
--       args = { "--connection", "listen://127.0.0.1:${port}" },
--     },
--   }
-- end

-- 适配器: gdb (GDB ≥ 14 原生 DAP)
if vim.fn.exepath("gdb") ~= "" then
  dap.adapters.gdb = function(callback, config)
    -- nvim-dap 的 executable adapter 从 options.cwd 决定 gdb 进程的工作目录，
    -- 而不是 config.cwd。这里动态取当前文件的目录，让 gdb 能解析相对源文件路径。
    local cwd = vim.fn.expand("%:p:h")
    if cwd == "" then
      cwd = vim.fn.getcwd()
    end
    callback {
      type = "executable",
      command = "gdb",
      args = { "--interpreter=dap" },
      name = "gdb",
      options = {
        cwd = cwd,
      },
    }
  end
end

-- ========================================
-- C/C++ 调试配置（C 和 C++ 共用）
-- ========================================
local function build_cpp_configs()
  -- 收集所有已注册的 C/C++ 适配器
  local adapters = {}
  local available = { "codelldb", "lldb", "gdb" }
  for _, name in ipairs(available) do
    if dap.adapters[name] then
      table.insert(adapters, name)
    end
  end

  if #adapters == 0 then
    return
  end

  local adapter_labels = {
    codelldb = "codelldb (LLDB)",
    -- lldb     = "lldb-dap (LLDB)",
    gdb      = "gdb",
  }

  -- 为每个可用适配器注册独立的配置
  local c_configs = {}
  for _, ad in ipairs(adapters) do
    local label = adapter_labels[ad] or ad
    table.insert(c_configs, {
      name = "(" .. label .. ") Launch current file",
      type = ad,
      request = "launch",
      program = function()
        local fname = vim.fn.expand("%:p:r")
        if vim.fn.executable(fname) == 1 then
          return fname
        end
        return vim.fn.input("Binary path: ", fname, "file")
      end,
      cwd = "${fileDirname}",
      stopOnEntry = false,
    })
    table.insert(c_configs, {
      name = "(" .. label .. ") Launch custom binary",
      type = ad,
      request = "launch",
      program = function()
        return vim.fn.input("Binary path: ", vim.fn.getcwd() .. "/", "file")
      end,
      args = function()
        local args_str = vim.fn.input("Program arguments (optional): ")
        return vim.split(args_str, " ")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    })
    -- gdb 不支持 attach by PID 的 DAP 协议，跳过
    if ad ~= "gdb" then
      table.insert(c_configs, {
        name = "(" .. label .. ") Attach by PID",
        type = ad,
        request = "attach",
        pid = function()
          return tonumber(vim.fn.input("Process PID: "))
        end,
        stopOnEntry = false,
      })
    end
  end

  dap.configurations.c = c_configs
  dap.configurations.cpp = c_configs
end

build_cpp_configs()
