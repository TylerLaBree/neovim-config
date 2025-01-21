require('os')

local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Workman Mode --
local layout = vim.env.KEYMAP

if layout == "workman" then
    -- (O)pen line -> (L)ine
    keymap("", "l", "o", opts)
    keymap("", "o", "l", opts)
    keymap("", "L", "O", opts)
    keymap("", "O", "L", opts)
    -- (N)ext -> (J)ump
    keymap("", "j", "n", opts)
    keymap("", "n", "j", opts)
    keymap("", "J", "N", opts)
    keymap("", "N", "J", opts)
    -- (E)nd of word -> (K)aboose of word
    keymap("", "k", "e", opts)
    keymap("", "e", "k", opts)
    keymap("", "K", "E", opts)
    keymap("", "E", "K", opts)
    -- (Y)ank -> (H)aul
    keymap("", "h", "y", opts)
    keymap("", "y", "h", opts)
    keymap("", "H", "Y", opts)
    keymap("", "Y", "H", opts)
end

-- Swap between daily journals quickly
keymap("n", "<C-n>", ":lua require('user.zk').open_journal_entry('next')<CR>", opts)
keymap("n", "<C-p>", ":lua require('user.zk').open_journal_entry('prev')<CR>", opts)
keymap("n", "<C-o>", ":lua require('user.zk').open_pdf()<CR>", opts)

-- Set escape to normal mode in term mode
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Normal --
-- Better window navigation
keymap("n", "<C-y>", "<C-w>h", opts)
-- keymap("n", "<C-n>", "<C-w>j", opts)
keymap("n", "<C-e>", "<C-w>k", opts)
keymap("n", "<C-o>", "<C-w>l", opts)

-- Swap between buffers quickly
keymap('n', 'gn', ':bnext<CR>', opts)
keymap('n', 'gp', ':bprevious<CR>', opts)
keymap('n', 'gd', ':bdelete<CR>', opts)

keymap("n", "<leader>e", ":Lex 30<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<C-y>", ":bnext<CR>", opts)
keymap("n", "<C-o>", ":bprevious<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-n>", ":m .+1<CR>==", opts)
keymap("v", "<A-e>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "N", ":move '>+1<CR>gv-gv", opts)
keymap("x", "E", ":move '<-2<CR>gv-gv", opts)
