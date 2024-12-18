local using_gnome = vim.env.DESKTOP_SESSION

require "user.lazy"
if using_gnome then
    require "user.style"
else
    require "user.style_simple"
end
require "user.options"
require "user.keymaps"
require "user.cmp"
require "user.vimtex"
require "user.python"
require "user.zk"
