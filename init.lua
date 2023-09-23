local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
vim.opt.runtimepath:prepend(lazypath)

-- Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
end

-- Move around open buffers
map("n", "]b", "<cmd>:bnext<CR>")
map("n", "[b", "<cmd>:bprevious<CR>")
map("n", "]B", "<cmd>:blast<CR>")
map("n", "[B", "<cmd>:bfirst<CR>")
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
map("n", "<C-f>", "<cmd>:MaximizerToggle<CR>")
-- Terminal mappings
map("t", "<C-[>", "<C-\\><C-n>") -- exit

require("lazy").setup {
    "folke/neodev.nvim",
    "m4xshen/hardtime.nvim",
    "samjwill/nvim-unception",
    "szw/vim-maximizer",
    "numToStr/Comment.nvim",
    "folke/which-key.nvim",
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",
    "RRethy/nvim-base16",
    "lewis6991/gitsigns.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    {"L3MON4D3/LuaSnip",
	run = "make install_jsregexp"},
    "neovim/nvim-lspconfig",
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
    },
    "onsails/lspkind-nvim",
    "james1236/backseat.nvim",
    "CoderCookE/vim-chatgpt",
    "andythigpen/nvim-coverage",
    "stevearc/conform.nvim",
    "mfussenegger/nvim-lint",
}

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
vim.cmd.colorscheme("base16-monokai")
-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

vim.diagnostic.config { virtual_text = false, update_in_insert = false }
map("n", "<leader>dd", vim.diagnostic.open_float)

require("coverage").setup {}

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format { bufnr = args.buf }
    end,
})

-- require("conform").setup {
--     formatters_by_ft = {
--         lua = { "stylua" },
--         python = { "ruff" },
--         toml = { "taplo" },
--         json = { "prettier" },
--         markdown = { "prettier" },
--     },
-- }

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
require("lint").linters_by_ft = {
    markdown = { "vale" },
    solidity = { "solhint" },
    python = { "ruff" },
}
-- Neodev has to be before lspconfig
require("neodev").setup {}
require("hardtime").setup {}
require("Comment").setup {}
require("backseat").setup { openai_model_id = "gpt-3.5-turbo" }
-- vim-chatgpt
vim.g.chat_gpt_mod = "gpt-3.5-turbo"

-- whichkey
require("which-key").setup {}

-- Gitsigns
require("gitsigns").setup {}

local lsp = require("lsp-zero").preset {
    setup_servers_on_start = false,
}

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps { buffer = bufnr }
end)

lsp.setup_servers { "tsserver", "rust_analyzer", "lua_ls", "pylsp", "solidity_ls_nomicfoundation" }

lsp.setup()

local cmp = require "cmp"
cmp.setup {
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
}
-- Parsers must be installed manually via :TSInstall
require("nvim-treesitter.configs").setup {}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local nls_builtins = require "null-ls.builtins"
require("null-ls").setup {
    sources = {
        nls_builtins.formatting.forge_fmt, -- solidity
        -- js,ts
        nls_builtins.formatting.rome.with { command = "biome" },
        nls_builtins.formatting.prettier.with { filetypes = { "solidity" } },
    },
    -- you can reuse a shared lspconfig on_attach callback here
    -- on_attach = function(client, bufnr)
    --     if client.supports_method "textDocument/formatting" then
    --         vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    --         vim.api.nvim_create_autocmd("BufWritePre", {
    --             group = augroup,
    --             buffer = bufnr,
    --             callback = function()
    --                 vim.lsp.buf.format()
    --             end,
    --         })
    --     end
    -- end,
}

local telescopeConfig = require "telescope.config"
local builtin = require "telescope.builtin"
-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I don't want to search in the `.git`, 'node_modules', or 'lib' directories.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!.git/*")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!node_modules/*")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!lib/*")
table.insert(vimgrep_arguments, "--trim")

require("telescope").setup {
    defaults = {
        vimgrep_arguments = vimgrep_arguments,
        layout_config = { width = 0.99, preview_cutoff = 1, preview_width = 0.5 },
    },
}

-- LPS actions
map("n", "<leader>d", builtin.diagnostics)
map("n", "<leader>r", builtin.lsp_references)
map("n", "<leader>t", builtin.lsp_type_definitions)
map("n", "<leader>i", builtin.lsp_implementations)
map("n", "<leader>b", builtin.buffers)
map("n", "<leader>f", builtin.git_files)
map("n", "<leader>g", builtin.live_grep)
map("n", "<leader>p", builtin.resume)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
