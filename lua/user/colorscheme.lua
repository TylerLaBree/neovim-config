local colorfamily = "rose-pine"
local colorscheme = "rose-pine-dawn"

if colorscheme == "adwaita" then
  vim.g.adwaita_darker = false -- for darker version
  vim.g.adwaita_disable_cursorline = false -- to disable cursorline
  --vim.g.adwaita_transparent = true -- makes the background transparent
end

if colorfamily == "adwaita" then
  vim.o.background = "dark"
end

if colorfamily == "zen" then
  vim.o.background = "dark"
end

if colorfamily == "catppuccin" then
  vim.o.background = "dark"
end

-- if colorscheme == "rose-pine" then
  -- vim.o.background = "light"
-- end

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
