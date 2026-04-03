local builtin = require("telescope.builtin")

vim.g.mapleader = " "

vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Don't want to go to cmd-line mode for this
vim.keymap.set("n", "<leader>q", ":q!<CR>",         { desc = "Quit without saving" })
vim.keymap.set("n", "<leader>w", ":w!<CR>",         { desc = "Force write" })
vim.keymap.set("n", "<leader>x", ":xa!<CR>",        { desc = "Save & quit all" })
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better Defaults
vim.keymap.set("n", "<C-h>", "<C-w>h",  { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j",  { desc = "Go to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k",  { desc = "Go to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l",  { desc = "Go to right window" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page Down + center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page Up + center cursor" })
vim.keymap.set("n", "n",     "nzzzv",   { desc = "Next match + center + open fold" })
vim.keymap.set("n", "N",     "Nzzzv",   { desc = "Prev match + center + open fold" })
vim.keymap.set("v", ">",     ">gv",     { desc = "Indent right" })
vim.keymap.set("v", "<",     "<gv",     { desc = "Outdent left" })
vim.keymap.set("n", "U",     "<C-r>",   { desc = "Better redo" })

-- Telescope keys
vim.keymap.set("n", "<leader>ff", builtin.find_files,                { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep,                 { desc = "Live grep (search in project)" })
vim.keymap.set("n", "<leader>fb", builtin.buffers,                   { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags,                 { desc = "Help tags" })
vim.keymap.set("n", "<leader>fc", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy find in current buffer" })
vim.keymap.set("n", "<leader>ft", builtin.colorscheme,               { desc = "Colorschemes" })

-- Manually alter something

vim.keymap.set("n", "<leader>td", function()
    local is_enabled = vim.diagnostic.is_enabled()
    vim.diagnostic.enable(not is_enabled)
    
    local status = not is_enabled and "Enabled" or "Disabled"
    print("Diagnostics " .. status)
end, { desc = "Toggle Diagnostics" })



vim.keymap.set("n", "<leader>tt", function()
    local buf = vim.api.nvim_get_current_buf()
    local highlighter = vim.treesitter.highlighter
    
    if highlighter.active[buf] then
        vim.treesitter.stop(buf)
        print("Tree-sitter Disabled")
    else
        vim.treesitter.start()
        print("Tree-sitter Enabled")
    end
end, { desc = "Toggle Tree-sitter" })



vim.keymap.set('n', '<leader>wt', function()
    local new_wrap = not vim.opt_local.wrap:get()
    vim.opt_local.wrap = new_wrap
    vim.opt_local.linebreak = new_wrap
    print("Wrap + linebreak: " .. (new_wrap and "ON" or "OFF"))
end, { desc = "Toggle wrap + linebreak" })
