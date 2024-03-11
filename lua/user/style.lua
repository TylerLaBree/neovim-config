function createSocket()
  pid = vim.fn.getpid()
  socket_name = '/tmp/nvim/nvim' .. pid .. '.sock'
  vim.fn.mkdir('/tmp/nvim', 'p')
  vim.fn.serverstart(socket_name)
end


function setColorscheme(c)
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. c)
  if not status_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
    return
  end
end


function updateColorscheme()
  command = "dbus-send --session --dest=org.freedesktop.portal.Desktop --print-reply /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:'org.freedesktop.appearance' string:'color-scheme' | grep -o 'uint32 .' | cut -d' ' -f2"

  handle = io.popen(command)
  output = handle:read("*a")
  handle:close()
  output = string.gsub(output, "\n", "")
  local colorscheme
  if output == "1" then
    -- Set dark colorscheme
    setColorscheme("komau")
    vim.o.background = "dark"
    vim.api.nvim_set_hl(0, "Normal", { bg = "#1E1E1E", fg = "#E2D4C8" })
  else
    -- Set light colorscheme
    setColorscheme("rose-pine")
    vim.o.background = "light"
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "#FFFAF3" })
  end

end


vim.api.nvim_create_augroup('custom_startup', {})

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Create a socket for every nvim process',
  group = 'custom_startup',
  once = true,
  callback = createSocket
})

vim.api.nvim_create_autocmd('UIEnter', {
  desc = 'Set the appropriate theme on startup',
  group = 'custom_startup',
  once = true,
  callback = updateColorscheme
})
