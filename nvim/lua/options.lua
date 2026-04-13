vim.opt.number  = true            -- Show line numbers
vim.opt.relativenumber = true     -- Show relative line numbers 
vim.opt.mouse  = "a"              -- Enable mouse support
vim.opt.clipboard = "unnamedplus" -- Use system clipboard for all yank/delete/put operations
vim.opt.undofile = true           -- Persistent undo
vim.opt.wrap  = false             -- Disable line wrapping
vim.opt.scrolloff = 1000            --


vim.opt.expandtab = true          -- Convert tabs to spaces 
vim.opt.shiftwidth = 4            -- Number of spaces in ()auto)indentation
vim.opt.tabstop = 4               -- Number of spaces a <Tab> is worth
vim.opt.smartindent = true        -- Smart auto-indenting on new lines


vim.opt.termguicolors = true      -- Enable 24-bit RGB colors in terminal
vim.opt.ignorecase = true         -- Case-insensitve search
vim.opt.incsearch = true          -- Incremental search
vim.opt.hlsearch = true           -- Highlight search matches
vim.opt.smartcase = true          -- Override ignorecase when search contains uppercase


vim.opt.cursorline = true         -- Highlight the current line
vim.opt.signcolumn = "yes"        -- Show sign column
vim.opt.inccommand = "split"      -- Show live preview of :substitute


vim.opt.backup = false            -- Don't create backup files
vim.opt.writebackup = false       -- Don't create backup before overwriting
vim.opt.swapfile = false          -- Don't create swap files


vim.api.nvim_create_autocmd("Filetype", {
    pattern = { "javascript", "typescript", "javascriptreac", "typescriptreact", "html", "css", "json", "dart", "ruby" },
    callback = function ()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.scrolloff = 2
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})
