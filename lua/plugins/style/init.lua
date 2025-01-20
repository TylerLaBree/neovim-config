M = {}
M.using_gnome = vim.env.DESKTOP_SESSION

M.setup = function(args)
    if M.using_gnome=="gnome" then
        require('plugins.style.freedesktop').setup(args)
    else
        require('plugins.style.simple').setup(args)
    end
end

return M
