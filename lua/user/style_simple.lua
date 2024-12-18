function setColorscheme(c)
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. c)
  if not status_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
    return
  end
end

-- Set light colorscheme
setColorscheme("rose-pine")
vim.o.background = "light"
-- vim.api.nvim_set_hl(0, "Normal", { bg = "#FFFAF3" })

