vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-buffer",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/echasnovski/mini.nvim",
    "https://github.com/sphamba/smear-cursor.nvim",
    "https://github.com/folke/tokyonight.nvim",
})

require("nvim-treesitter.config").setup({
    ensure_installed = { "lua", "vim", "vimdoc", "query" },
    highlight = true,
    indent = true,
})

-- require('telescope').setup({})

local cmp = require("cmp")

cmp.setup({
    sources = {
        { name = "buffer"},
        { name = "path" },
    },

    mapping = cmp.mapping.preset.insert({
        ["<Tab>"]   = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"]    = cmp.mapping.confirm({ select = true }),
        ["<C-e>"]   = cmp.mapping.abort(),
      }),
})

require("mini.pairs").setup()

require("smear_cursor").setup({
    legacy_computing_symbols_support = true,
    trailing_stiffness = 0.2,
    damping = 0.7,
})

require("tokyonight").setup({
    transparent = true,
})

vim.cmd.colorscheme("tokyonight")
