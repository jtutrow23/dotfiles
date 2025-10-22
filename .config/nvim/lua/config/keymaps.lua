local map = vim.keymap.set
local silent = { silent = true, noremap = true }

-- Better window navigation
map("n", "<C-h>", "<C-w>h", silent)
map("n", "<C-j>", "<C-w>j", silent)
map("n", "<C-k>", "<C-w>k", silent)
map("n", "<C-l>", "<C-w>l", silent)

-- Resize splits
map("n", "<A-Left>",  ":vertical resize -3<CR>", silent)
map("n", "<A-Right>", ":vertical resize +3<CR>", silent)
map("n", "<A-Up>",    ":resize +3<CR>", silent)
map("n", "<A-Down>",  ":resize -3<CR>", silent)

-- Save/Quit
map("n", "<leader>w", "<cmd>w<cr>", silent)
map("n", "<leader>q", "<cmd>q<cr>", silent)

-- Clear highlights
map("n", "<esc>", "<cmd>nohlsearch<cr>", silent)

-- Oil (filesystem) & Telescope
map("n", "-",      "<cmd>Oil<cr>", silent)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", silent)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",  silent)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",    silent)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",  silent)

-- Toggle relative numbers
map("n", "<leader>rn", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, silent)