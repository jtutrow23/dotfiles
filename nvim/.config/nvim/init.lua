-- Minimal Neovim baseline (no plugins)
-- Philosophy: explicit, fast startup, sane defaults.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.showmode = false

-- Editing
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false

-- Files
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Behavior
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.clipboard = "unnamedplus"

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Diagnostics (less noisy)
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Minimal keymaps
local map = vim.keymap.set
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<C-h>", "<C-w>h", { desc = "Left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Down split" })
map("n", "<C-k>", "<C-w>k", { desc = "Up split" })
map("n", "<C-l>", "<C-w>l", { desc = "Right split" })
