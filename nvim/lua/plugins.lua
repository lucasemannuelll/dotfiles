local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- nvim-treesitter
-- nvim-cmp {cmp-nvim-lsp, cmp-path, cmp-buffer}
-- telescope {plenary}
-- mini-pairs {standalone}
-- smear-cursor
-- tokyonight

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    version = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = { 'lua', 'vim', 'vimdoc', 'query' },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },

    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = {
          { name = "buffer", keyword_length = 3 },
          { name = "path" },
        },

        mapping = cmp.mapping.preset.insert({
          ["<Tab>"]     = cmp.mapping.select_next_item(),
          ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<C-e>"]     = cmp.mapping.abort(),
        }),
      })
    end,
  },

  {
    'nvim-mini/mini.pairs',
    config = function()
      require('mini.pairs').setup()
    end,
  },

  {
    "sphamba/smear-cursor.nvim",
    opts = {
        legacy_computing_symbols_support = true,
        trailing_stiffness = 0.2,
        damping = 0.7,
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            transparent = true,
        })
        vim.cmd.colorscheme("tokyonight")
    end
  },
})
