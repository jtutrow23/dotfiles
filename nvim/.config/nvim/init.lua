-- Minimal Neovim baseline
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
vim.opt.background = "dark"

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

-- Keymaps
local map = vim.keymap.set
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<C-h>", "<C-w>h", { desc = "Left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Down split" })
map("n", "<C-k>", "<C-w>k", { desc = "Up split" })
map("n", "<C-l>", "<C-w>l", { desc = "Right split" })

-- Theme: Tokyonight (exact, if installed)
vim.g.tokyonight_style = "storm"
vim.g.tokyonight_transparent = false
vim.g.tokyonight_terminal_colors = true

local ok_theme, _ = pcall(vim.cmd.colorscheme, "tokyonight")
if not ok_theme then
  -- Theme not installed yet; stay usable.
  vim.cmd.colorscheme("default")
end

-- LSP (incremental, nvim 0.11+)
local function lsp_on_attach(_, bufnr)
  local function bmap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  bmap("n", "gd", vim.lsp.buf.definition, "LSP: go to definition")
  bmap("n", "gr", vim.lsp.buf.references, "LSP: references")
  bmap("n", "K",  vim.lsp.buf.hover, "LSP: hover")
  bmap("n", "<leader>rn", vim.lsp.buf.rename, "LSP: rename")
  bmap("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: code action")
  bmap("n", "[d", vim.diagnostic.goto_prev, "Diag: prev")
  bmap("n", "]d", vim.diagnostic.goto_next, "Diag: next")
  bmap("n", "<leader>e", vim.diagnostic.open_float, "Diag: float")
end

-- Configure + enable servers using Neovim's built-in API (0.11+)
vim.lsp.config("pyright", {
  on_attach = lsp_on_attach,
})

vim.lsp.enable("pyright")
