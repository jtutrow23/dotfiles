-- Plugin specs for lazy.nvim. Keep it tight and useful.

return {

  -- Colorscheme (pick one at the end)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = { flavour = "frappe", integrations = { which_key = true, treesitter = true, gitsigns = true } },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- UI: statusline
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "auto", section_separators = "", component_separators = "" } } },

  -- File explorer (Oil = edit filesystem like a buffer)
  { "stevearc/oil.nvim", opts = { view_options = { show_hidden = true } } },

  -- Telescope (fuzzy everything)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    opts = function()
      local actions = require("telescope.actions")
      return { defaults = { mappings = { i = { ["<esc>"] = actions.close } } } }
    end
  },

  -- Treesitter (syntax & structure)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = { "lua", "vim", "vimdoc", "bash", "markdown", "markdown_inline", "python", "javascript", "typescript" },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end
  },

  -- Git signs in the gutter
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- which-key (discoverability)
  { "folke/which-key.nvim", opts = { delay = 200 } },

  -- Comment toggling
  { "numToStr/Comment.nvim", opts = {} },

  -- Autopairs
  { "windwp/nvim-autopairs", opts = {} },
}