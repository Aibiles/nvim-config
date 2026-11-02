# nvim-config

基于 [NvChad](https://github.com/NvChad/NvChad) v2.5 的个人 Neovim 配置。

## 特性

- **主题**：`tokyodark`
- **LSP**：`lua_ls`、`clangd`、`basedpyright`（由 mason 管理）
- **格式化**：`conform.nvim`（stylua / clang-format / ruff）
- **Lint**：`nvim-lint`（luacheck）
- **调试**：`nvim-dap` + `nvim-dap-ui` + `nvim-dap-virtual-text`，支持
  - C/C++（codelldb / lldb-dap / gdb，启动时自动检测可用后端）
  - Python（debugpy + nvim-dap-python）
- **其它**：lazygit、nvim-surround、vimtex、render-markdown、trouble

## 安装

```bash
# 克隆到配置目录
git clone git@github.com:Aibiles/nvim-config.git ~/.config/nvim

# 首次启动会自动 bootstrap lazy.nvim 并安装插件
nvim
```

> 需要 Neovim 0.10+（推荐 0.11+，本配置使用 `vim.lsp.config` 新 API）。

## 调试器依赖

C/C++ 调试需要至少一个后端（按需安装其一）：

```bash
yay -S codelldb          # LLDB（功能最全）
sudo pacman -S lldb      # lldb-dap（轻量）
sudo pacman -S gdb       # GDB ≥ 14
```

Python 调试需要 `debugpy`（由 mason-nvim-dap 自动安装）。

## 结构

```
lua/
├── chadrc.lua          # 主题 / UI 覆写
├── options.lua         # 编辑器选项
├── mappings.lua        # 按键映射
├── plugins/            # 插件定义（按模块拆分）
└── configs/            # 各插件的实际配置
```

## Credits

- [NvChad/NvChad](https://github.com/NvChad/NvChad)
- [LazyVim/starter](https://github.com/LazyVim/starter)（NvChad starter 的灵感来源）
