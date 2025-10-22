local o = vim.opt

o.termguicolors = true
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.wrap = false
o.scrolloff = 6
o.sidescrolloff = 8

o.ignorecase = true
o.smartcase = true
o.incsearch = true

o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

o.splitright = true
o.splitbelow = true

o.undofile = true
o.updatetime = 200
o.timeoutlen = 400

-- performance niceties
o.lazyredraw = true
o.synmaxcol = 240