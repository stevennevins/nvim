require('packer').startup(function(use)
    use 'wbthomason/packer.nvim' -- Package manager
    use 'RRethy/nvim-base16'
    use 'nvim-lua/plenary.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'nvim-lualine/lualine.nvim'
    use 'kdheepak/tabline.nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-telescope/telescope.nvim'
    use 'olacin/telescope-gitmoji.nvim'
    use 'pwntester/octo.nvim'
    use 'petertriho/cmp-git'
    use 'numToStr/Comment.nvim'
    use 'tpope/vim-projectionist'
    use 'folke/which-key.nvim'
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

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.relativenumber = true
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

-- Highlight on yank
vim.cmd('colorscheme base16-gruvbox-dark-medium')
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', {noremap = true, silent = true})
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('octo').setup()
-- Copilot
require("copilot").setup {}
require("copilot_cmp").setup {}
-- comment
require('Comment').setup()

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

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

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
        map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map({'n', 'v'}, '<leader>gp', ':term git push<CR> :bd')
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

-- vim-projectionist
vim.cmd [[
let g:projectionist_heuristics = {
\ '*':{
\    'src/**/*.sol':{'alternate': 'test/**/{}.t.sol'},
\   'test/**/*.t.sol':{'alternate': 'src/**/{}.sol'},
\    'src/*.sol':{'alternate': 'test/{}.t.sol'},
\   'test/*.t.sol':{'alternate':'src/{}.sol'}
\}
\}
]]

-- Lsp setup
require'lspconfig'.solidity.setup {
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol
                                                                    .make_client_capabilities()),
    on_attach = function(client)
        -- unsupported in lsp atm
        vim.api.nvim_buf_set_keymap(0, 'n', 'K',
                                    '<cmd>lua vim.lsp.buf.hover()<CR>',
                                    {noremap = true})
        vim.api.nvim_buf_set_keymap(0, 'n', 'gT',
                                    '<cmd>lua vim.lsp.buf.type_definition()<CR>',
                                    {noremap = true})
        vim.api.nvim_buf_set_keymap(0, 'n', 'gi',
                                    '<cmd>lua vim.lsp.buf.implementation()<CR>',
                                    {noremap = true})
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dn',
                                    '<cmd>lua vim.diagnostic.goto_next<CR>',
                                    {noremap = true})
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dp',
                                    '<cmd>lua vim.diagnostic.goto_prev<CR>',
                                    {noremap = true})
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dl',
                                    '<cmd>Telescope diagnostics<CR>',
                                    {noremap = true})
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>r',
                                    '<cmd>lua vim.lsp.buf.rename()<CR>',
                                    {noremap = true})
        -- supported in lsp
        vim.api.nvim_buf_set_keymap(0, 'n', 'gd',
                                    '<cmd>lua vim.lsp.buf.definition()<CR>',
                                    {noremap = true})
    end
}

require'lspconfig'.pyright.setup {}

-- Setup nvim-cmp.
vim.opt.completeopt = {"menu", "menuone", "noselect"}
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
        enable = true -- false will disable the whole extension
    }
}

local parser_config = require"nvim-treesitter.parsers".get_parser_configs()
parser_config.sol = {
    install_info = {
        url = "https://github.com/JoranHonig/tree-sitter-solidity", -- local path or git repo
        files = {"src/parser.c"},
        -- optional entries:
        branch = "master", -- default branch in case of git repo if different from master
        generate_requires_npm = true, -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = false -- if folder contains pre-generated src/parser.c
    },
    filetype = "sol" -- if filetype does not match the parser name
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.diagnostics.solhint,
        require("null-ls").builtins.formatting.lua_format,
        require("null-ls").builtins.formatting.prettierd.with({
            filetypes = {"solidity", "python", "javascript", "json"}
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
-- Telescope Setup
local action_state = require('telescope.actions.state') -- runtime (Plugin) exists somewhere

require('telescope').setup {
    defaults = {
        prompt_prefix = "$ ",
        mappings = {
            i = {
                ["<c-a>"] = function()
                    print(vim.inspect(action_state.get_selected_entry()))
                end
            }
        }
    }
}

require('telescope').load_extension("gitmoji")
vim.api.nvim_set_keymap('n', '<leader>c',
                        [[<cmd>lua require('telescope').extensions.gitmoji.gitmoji()<CR>]],
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader><space>',
                        [[<cmd>lua require('telescope.builtin').buffers()<CR>]],
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>f',
                        [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]],
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ff',
                        [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]],
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fh',
                        [[<cmd>lua require('telescope.builtin').help_tags()<CR>]],
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ft',
                        [[<cmd>lua require('telescope.builtin').tags()<CR>]],
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fs',
                        [[<cmd>lua require('telescope.builtin').grep_string()<CR>]],
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fg',
                        [[<cmd>lua require('telescope.builtin').live_grep()<CR>]],
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ftt',
                        [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]],
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>?',
                        [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]],
                        {noremap = true, silent = true})

local mappings = {}

mappings.curr_buf = function()
    local opt = require('telescope.themes').get_dropdown({
        height = 10,
        previewer = false
    })
    require('telescope.builtin').current_buffer_fuzzy_find(opt)
end
return mappings
