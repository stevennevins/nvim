require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'lewis6991/impatient.nvim'
    use "samjwill/nvim-unception"
    use 'prichrd/netrw.nvim'
    use 'numToStr/Comment.nvim'
    use 'kylechui/nvim-surround'
    use 'folke/which-key.nvim'
    use {"catppuccin/nvim", as = "catppuccin"}
    use 'nvim-lua/plenary.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'nvim-lualine/lualine.nvim'
    use 'kdheepak/tabline.nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    use 'nvim-telescope/telescope.nvim'
    use 'petertriho/cmp-git'
    use 'zbirenbaum/copilot.lua'
    use 'zbirenbaum/copilot-cmp'
    use "jose-elias-alvarez/null-ls.nvim"
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
end)

require("impatient")

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.number = true
vim.o.termguicolors = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wildmode = 'longest:full,full'
vim.o.wrap = false
vim.o.list = true
vim.o.listchars = 'tab:▸ ,trail:·'
vim.o.mouse = 'a'
vim.o.scrolloff = 25
vim.o.clipboard = 'unnamedplus'
vim.o.undofile = true -- persistent undo
vim.o.confirm = true
vim.o.backup = false

-- Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', {noremap = true, silent = true})
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
end

-- Move around open buffers
map('n', ']b', '<cmd>:bnext<CR>')
map('n', '[b', '<cmd>:bprevious<CR>')
map('n', ']B', '<cmd>:blast<CR>')
map('n', '[B', '<cmd>:bfirst<CR>')
-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
-- Terminal mappings
map('t', '<C-[>', '<C-\\><C-n>') -- exit

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

vim.cmd.colorscheme "catppuccin"
vim.diagnostic.config({virtual_text = false, update_in_insert = true})
map('n', '<leader>d', vim.diagnostic.open_float)

require'netrw'.setup {}
-- Copilot
require("copilot").setup {}
require("copilot_cmp").setup {}
-- comment
require('Comment').setup()

require('nvim-surround').setup()

-- Lualine
require('lualine').setup {
    options = {
        theme = "auto",
        component_separators = '',
        section_separators = ''
    }
}

-- tabline setup
require('tabline').setup {}

-- whichkey
require('which-key').setup {}

-- Gitsigns
require('gitsigns').setup {
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, {expr = true})

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, {expr = true})

        -- Actions
        map({'n', 'v'}, '<leader>hs', gs.stage_hunk)
        map({'n', 'v'}, '<leader>hr', gs.reset_hunk)
        map({'n', 'v'}, '<leader>gp', ':term git push<CR> :bd<CR>')
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line {full = true} end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
}

-- Lsp setup
require'lspconfig'.solidity.setup {
    on_attach = function(client)
        map('n', 'rn', vim.lsp.buf.rename)
        map('n', 'gd', vim.lsp.buf.definition)
        map('n', '<leader>k', vim.lsp.buf.hover)
        map('n', '[d', vim.diagnostic.goto_next)
        map('n', ']d', vim.diagnostic.goto_prev)
    end
}

require'lspconfig'.pyright.setup {}
require'lspconfig'.gopls.setup {}
require'lspconfig'.rust_analyzer.setup {}

-- Setup nvim-cmp.
vim.opt.completeopt = {"menuone", "noselect"}
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                          col)
                   :match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true),
                          mode, true)
end
local cmp = require('cmp')
cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        -- ['C-y'] accepts snippet
        ['<CR>'] = cmp.mapping.confirm({select = true}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
                cmp.complete()
            else
                fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
        end, {"i", "s"}),

        ["<C-p>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, {"i", "s"})
    }),
    sources = cmp.config.sources({
        {name = 'nvim_lsp'}, {name = 'vsnip'}, {name = "null-ls"},
        {name = 'copilot'}, {name = 'git'}
    }, {{name = 'buffer'}})
}
-- setup git completion
require("cmp_git").setup()
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = false
    }
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.diagnostics.solhint,
        require("null-ls").builtins.formatting.lua_format,
        require("null-ls").builtins.formatting.gofumpt,
        require("null-ls").builtins.formatting.rustfmt,
        require("null-ls").builtins.diagnostics.golangci_lint,
        require("null-ls").builtins.formatting.prettierd.with({
            filetypes = {"solidity", "python", "javascript", "json", "md"}
        })
    },
    -- you can reuse a shared lspconfig on_attach callback here
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function() vim.lsp.buf.format() end
            })
        end
    end
})

local telescope = require("telescope")
local telescopeConfig = require("telescope.config")
local builtin = require('telescope.builtin')
-- Clone the default Telescope configuration
local vimgrep_arguments = {unpack(telescopeConfig.values.vimgrep_arguments)}

-- I don't want to search in the `.git`, 'node_modules', or 'lib' directories.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!.git/*")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!node_modules/*")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!lib/*")
table.insert(vimgrep_arguments, "--trim")

require('telescope').setup {
    defaults = {
        vimgrep_arguments = vimgrep_arguments,
        layout_config = {width = 0.99, preview_cutoff = 1, preview_width = 0.66}
    }
}
require('telescope').load_extension('fzf')
map('n', '<leader>fd', builtin.diagnostics)
map('n', '<leader>rf', builtin.lsp_references)
map('n', '<leader>b', builtin.buffers)
map('n', '<leader>f', builtin.git_files)
map('n', '<leader>g', builtin.live_grep)
map('n', '<leader>p', builtin.resume)
