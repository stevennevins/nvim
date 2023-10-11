-- Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
end

-- Move around splits using Ctrl + {h,j,k,l}
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-v>", "<cmd>:vsp | term<CR>")
map("n", "<C-x>", "<cmd>:bd<CR>")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
-- map window maxize toggle
map("n", "<C-f>", "<cmd>:ZenMode<CR>")
-- Terminal mappings
map("t", "<C-[>", "<C-\\><C-n>") -- exit

vim.keymap.set("n", "<leader>q", "<cmd>:copen<cr>", {})
vim.keymap.set("n", "<leader>Q", "<cmd>:cclose<cr>", {})
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", {})
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", {})
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", {})
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", {})
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", {})
vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", {})
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", {})
vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", {})
vim.keymap.set("n", "rn", "<cmd>lua vim.lsp.buf.rename()<cr>", {})
vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", {})
vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", {})
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", {})
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", {})
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", {})
