local ok, get_package = pcall(function()
    return require("mason-registry").get_package
end)
if ok and get_package then
    require("dap-python").setup(get_package("debugpy"):get_install_path() .. "/venv/bin/python")
end

local map = vim.keymap.set

map("n", "<leader>dpr", function()
    require("dap-python").test_method()
end, { desc = "Run DAP Python test method" })
