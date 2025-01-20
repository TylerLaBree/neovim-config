-- main module file

---@class Config
---@field opt string Your config option
local config = {
  opt = "Hello!",
}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@param args Config?
-- you can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
function M.setup(args)
    -- Set light colorscheme
    pcall(vim.cmd, "colorscheme rose-pine")
    vim.o.background = "light"
  require('lualine').setup()
end

return M
