local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local grp = aug("jt-core", { clear = true })

-- Highlight on yank
au("TextYankPost", {
  group = grp,
  callback = function() vim.highlight.on_yank { timeout = 120 } end
})

-- Quit help/qf with 'q'
au("FileType", {
  group = grp,
  pattern = { "help", "qf" },
  callback = function(args) vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = args.buf, silent = true }) end
})