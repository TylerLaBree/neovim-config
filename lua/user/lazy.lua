local using_gnome = not vim.env.DESKTOP_SESSION
--
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- the colorscheme should be available when starting Neovim
    -- Colorschemes
    { "rose-pine/neovim", name = "rose-pine", lazy = false },
    { "Mofiqul/adwaita.nvim"},    -- Sick adwaita theme
    { "ntk148v/komau.vim", lazy = false },       -- Simple sepia themes

    -- UI
    {
        "zk-org/zk-nvim",
        config = function()
            require("zk").setup({
                -- can be "telescope", "fzf", "fzf_lua", "minipick", or "select" (`vim.ui.select`)
                -- it's recommended to use "telescope", "fzf", "fzf_lua", or "minipick"
                picker = "select",

                lsp = {
                    -- `config` is passed to `vim.lsp.start_client(config)`
                    config = {
                    cmd = { "zk", "lsp" },
                    name = "zk",
                    -- on_attach = ...
                    -- etc, see `:h vim.lsp.start_client()`
                    },

                    -- automatically attach buffers in a zk notebook that match the given filetypes
                    auto_attach = {
                    enabled = true,
                    filetypes = { "markdown" },
                    },
                },
            })
        end,
    },
    { -- Bug-free replacement for true-zen.
        "cdmill/focus.nvim", 
        cmd = { "Focus", "Zen", "Narrow" }, 
        opts = {
            window = {
                backdrop = 1,
                width = 100,
            }
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    -- { "pocco81/true-zen.nvim", event = "VeryLazy" },   -- simple editing zen mode
    { "Bekaboo/deadcolumn.nvim" }, -- Better colorcolumn that appears when approaching
    { "jose-elias-alvarez/buftabline.nvim" },     -- shows each buffer as a tab
    {
        "RRethy/vim-hexokinase",
        build = "make hexokinase",
        cond = using_gnome,
        init = function()
            vim.g.Hexokinase_highlighters = { "virtual" }
        end,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
        config = function()
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = { "*.md", "*.markdown" },
                callback = function()
                    vim.cmd("TSBufEnable highlight")
                end,
            })
        end,
    },
    {
    	-- LLM functionality
    	"yetone/avante.nvim",
        cond = using_gnome,
    	event = "VeryLazy",
    	lazy = false,
    	version = false, -- set this if you want to always pull the latest change
    	opts = {
            provider = "openai",
            auto_suggestions_provider = "openai",
    	},
    	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    	build = "make",
    	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    	dependencies = {
        	"nvim-treesitter/nvim-treesitter",
        	"stevearc/dressing.nvim",
        	"nvim-lua/plenary.nvim",
        	"MunifTanjim/nui.nvim",
        	--- The below dependencies are optional,
        	"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    	},
	},
    
    -- Other
    { "L3MON4D3/LuaSnip" },        -- Snippet tool
    { "rafamadriz/friendly-snippets" },  -- List of snippets
    { "hrsh7th/nvim-cmp" },        -- The completion plugin
    { "hrsh7th/cmp-buffer" },      -- buffer completions
    { "hrsh7th/cmp-path" },        -- path completions
    { "hrsh7th/cmp-cmdline" },     -- cmdline completions
    { "saadparwaiz1/cmp_luasnip" },-- Compatibility
    { "lervag/vimtex" },           -- LaTeX compiling
    
    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        -- init is called during startup. Configuration for vim plugins typically should be set in an init function
        init = function()
        vim.g.startuptime_tries = 10
        end,
    },
    
    -- if some code requires a module from an unloaded plugin, it will be automatically loaded.
    -- So for api plugins like devicons, we can always set lazy=true
    { "nvim-tree/nvim-web-devicons", lazy = true },
    
    
    
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
