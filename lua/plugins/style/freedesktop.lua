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
M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
    vim.api.nvim_create_augroup('custom_startup', {})

    vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'Create a socket for every nvim process',
    group = 'custom_startup',
    once = true,
    callback = M.createSocket
    })

    vim.api.nvim_create_autocmd('UIEnter', {
    desc = 'Set the appropriate theme on startup',
    group = 'custom_startup',
    once = true,
    callback = M.updateColorscheme
    })
end

function M.createSocket()
  pid = vim.fn.getpid()
  socket_name = '/tmp/nvim/nvim' .. pid .. '.sock'
  vim.fn.mkdir('/tmp/nvim', 'p')
  vim.fn.serverstart(socket_name)
end


function M.setColorscheme(c)
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. c)
  if not status_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
    return
  end
  require('lualine').setup()
end


function M.updateColorscheme()
  command = "dbus-send --session --dest=org.freedesktop.portal.Desktop --print-reply /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:'org.freedesktop.appearance' string:'color-scheme' | grep -o 'uint32 .' | cut -d' ' -f2"

  handle = io.popen(command)
  output = handle:read("*a")
  handle:close()
  output = string.gsub(output, "\n", "")
  local colorscheme
  if output == "1" then
    -- Set dark colorscheme
    vim.o.background = "dark"
    M.setColorscheme("komau")
    vim.api.nvim_set_hl(0, "Normal", { bg = "#1E1E1E", fg = "#E2D4C8" })
    vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true })
    vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true })
    vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true })
    vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true })
    vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#F5EEE6", bg = "#303030" })
    vim.api.nvim_set_hl(0, "DiffChange", { fg = "#F5EEE6", bg = "#303030" })
    vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#F5EEE6", bg = "#303030" })

  else
    -- Set light colorscheme
    vim.o.background = "light"
    M.setColorscheme("rose-pine")
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "#FFFAF3" })
  end
end

return M

