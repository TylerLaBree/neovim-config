local using_gnome = vim.env.DESKTOP_SESSION

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

local plugins = {
    -- the colorscheme should be available when starting Neovim
    -- Colorschemes
    {
        dir = "/home/tyler/.config/nvim/lua/plugins/style",
        name = "style",
        priority = 999,
        dependencies = { 'nvim-lualine/lualine.nvim', 'nvim-tree/nvim-web-devicons', "rose-pine/neovim", "ntk148v/komau.vim" },
        config = function ()
            require('plugins.style.init').setup()
            require('lualine').setup()
        end
    },

    -- UI
    {
        "zk-org/zk-nvim",
        dependencies = { 'ibhagwan/fzf-lua'},
        config = function()
            require("zk").setup({
                -- can be "telescope", "fzf", "fzf_lua", "minipick", or "select" (`vim.ui.select`)
                -- it's recommended to use "telescope", "fzf", "fzf_lua", or "minipick"
                picker = "fzf_lua",

                lsp = {
                    config = {
                        cmd = { "zk", "lsp" },
                        name = "zk",
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
                width = 93,
            }
        }
    },
    { "Bekaboo/deadcolumn.nvim" }, -- Better colorcolumn that appears when approaching
    { "jose-elias-alvarez/buftabline.nvim" },     -- shows each buffer as a tab
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        config = function()
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = { "*.md", "*.markdown" },
                callback = function()
                    vim.cmd("TSBufEnable highlight")
                end,
            })
            require('render-markdown').setup({
                latex = {
                    enabled = false,
                },
                code = {
                    style = 'normal',
                    border = 'thick',
                    position = 'right',
                    width = 'block',
                    left_pad = 2,
                    right_pad = 4,
                    sign = false,
                },
            })
        end,
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
    { "nvim-lua/plenary.nvim" },   -- Extra functions

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
}

if using_gnome then

    table.insert(plugins, {
        "RRethy/vim-hexokinase",
        build = "make hexokinase",
        cond = using_gnome,
        init = function()
            vim.g.Hexokinase_highlighters = { "virtual" }
        end,
    })

    --[[
    table.insert(plugins, {
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
    })
    --]]
end
    

-- Setup lazy.nvim
require("lazy").setup({
  spec = { plugins },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
  defaults = {
      version = "*"
  }
})
