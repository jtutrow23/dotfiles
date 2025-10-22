-- Minimal, fast Neovim using lazy.nvim
-- All user config lives in lua/config/*; plugins in lua/plugins.lua

-- Set <leader> early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim ---------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Core settings
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Plugins
require("lazy").setup({
  spec = {
    { import = "config.plugins" },
  },
  change_detection = { notify = false },
  install = { colorscheme = { "catppuccin", "tokyonight", "habamax" } },
  checker = { enabled = false }, -- you can enable periodic plugin update checks
})