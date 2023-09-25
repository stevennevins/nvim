vim.o.splitright = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wildmode = "longest:full,full"
vim.o.wrap = true
vim.o.linebreak = true
vim.o.nolist = true
vim.o.list = true
vim.o.listchars = "tab:▸ ,trail:·"
vim.o.mouse = "a"
vim.o.scrolloff = 25
vim.o.clipboard = "unnamedplus"
vim.o.undofile = true -- persistent undo
vim.o.confirm = true
vim.o.backup = false
vim.o.ttyfast = true
vim.o.termguicolors = true

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])

vim.diagnostic.config({ virtual_text = false, update_in_insert = false })
