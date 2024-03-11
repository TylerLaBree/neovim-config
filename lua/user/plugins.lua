local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- My plugins here
return packer.startup(function(use)
  use "wbthomason/packer.nvim"  -- Have packer manage itself
  -- Colorschemes
  use "mcchrish/zenbones.nvim"  -- Sick zen colorschemes
  use "rktjmp/lush.nvim"        -- Dependency for zenbones
  use({ 'rose-pine/neovim', as = 'rose-pine' })
  use "Mofiqul/adwaita.nvim"    -- Sick adwaita theme
  use({"catppuccin/vim", as = "catppuccin"})
  use "Soares/base16.nvim"      -- Simple colorschemes
  use "ntk148v/komau.vim"       -- Simple sepia themes
  use "pocco81/true-zen.nvim"   -- simple editing zen mode
  -- Other
  use "L3MON4D3/LuaSnip"        -- Snippet tool
  use "rafamadriz/friendly-snippets"  -- List of snippets
  use "hrsh7th/nvim-cmp"        -- The completion plugin
  use "hrsh7th/cmp-buffer"      -- buffer completions
  use "hrsh7th/cmp-path"        -- path completions
  use "hrsh7th/cmp-cmdline"     -- cmdline completions
  use "saadparwaiz1/cmp_luasnip"-- Compatibility
  use "lervag/vimtex"           -- LaTeX compiling
  use "Bekaboo/deadcolumn.nvim" -- Better colorcolumn that appears when I approach
  -- use "averms/black-nvim"       -- python formatter
  -- use "ixru/nvim-markdown"      -- markdown concealing
  -- use "tiagovla/scope.nvim"     -- shows each buffer as a tab
  use "ap/vim-buftabline"       -- i dunno
  -- use "sewdohe/nvim-adapt"      -- Sync light/dark mode with gnome
  use({
    "RRethy/vim-hexokinase",
    run = "make hexokinase",
    setup = function()
        vim.g.Hexokinase_highlighters = { "virtual" }
    end,
  })

  -- use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  -- use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
