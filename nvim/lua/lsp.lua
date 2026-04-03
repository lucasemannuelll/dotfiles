vim.lsp.config('lua_lsp', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
})

vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp' },
})

vim.lsp.config('rust_lsp',{
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' }
})

vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' }
})

vim.lsp.enable('lua_lsp')
vim.lsp.enable('clangd')
vim.lsp.enable('rust_lsp')
vim.lsp.enable('pyright')

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})
