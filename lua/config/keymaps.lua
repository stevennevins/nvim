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
map("n", "<leader>dd", vim.diagnostic.open_float)
