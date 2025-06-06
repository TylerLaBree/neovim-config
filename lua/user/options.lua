-- vim.opt.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
vim.opt.backup = false                          -- creates a backup file
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = "a"                             -- allow the mouse to be used in neovim
vim.opt.mousescroll = "ver:1,hor:1"
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.showtabline = 4                         -- always show tabs
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 300                        -- faster completion (4000ms default)
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 4                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4                             -- insert 2 spaces for a tab
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.breakindent = true
vim.opt.relativenumber = true                   -- set relative numbered lines
vim.opt.numberwidth = 1                         -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.scrolloff = 3                           -- is one of my fav
vim.opt.sidescrolloff = 10
vim.opt.fillchars = {eob = " "}                 -- hide end of buffer characters
vim.g.do_filetype_lua = 1
vim.g.python3_host_prog ='/home/tyler/.local/venv/nvim/bin/python'

vim.api.nvim_create_autocmd('BufWritePost', {
    desc = 'Compile markdown presentation with marp',
    pattern = '/home/tyler/Documents/Notes/dune-weekly/*.md',
    callback = function()
        require('user.zk').compile_with_marp()
    end
})


-- Text file settings
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"markdown", "text"},
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"

    vim.opt_local.wrap = false
    vim.opt_local.linebreak = true

    vim.opt_local.breakindent = true
    vim.opt_local.breakindentopt = "list:2"

    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2

    vim.opt_local.textwidth = 88

    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.sidescrolloff = 0
  end
})

-- Auto scroll left
function move_view_left()
    if vim.g.enable_left_scroll and vim.fn.mode() == 'n' then
        vim.api.nvim_command('normal! ze')
    end
end
vim.g.enable_left_scroll = true
vim.api.nvim_create_user_command(
    'ToggleLeftScroll',
    function()
        vim.g.enable_left_scroll = not vim.g.enable_left_scroll
        if vim.g.enable_left_scroll then
            print("Left-scroll enabled")
        else
            print("Left-scroll disabled")
        end
    end,
    {}
)
vim.cmd([[
    autocmd CursorMoved,TextChanged * lua move_view_left()
]])
