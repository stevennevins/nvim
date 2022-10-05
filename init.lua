-- Install packer
local install_path = vim.fn.stdpath 'data' ..
                         '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
                       install_path)
end

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim' -- Package manager
    use 'neovim/nvim-lspconfig'
    use 'RRethy/nvim-base16'
    use 'numToStr/Comment.nvim'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-projectionist'
    use 'folke/which-key.nvim'
    use {'samodostal/image.nvim', requires = 'nvim-lua/plenary.nvim'}
    use {'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim'}
    use {'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim'}
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    use 'nvim-treesitter/nvim-treesitter'
    use 'RRethy/vim-illuminate'
    use 'nvim-lualine/lualine.nvim' -- Fancier statusline
    use {'kdheepak/tabline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
    use {"jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim"}
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-copilot'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'github/copilot.vim'
end)

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.signcolumn = 'yes'
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
vim.o.confirm = true
vim.o.backup = false

-- Highlight on yank
vim.cmd('colorscheme base16-gruvbox-material-dark-hard')
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
    signs = {
        add = {
            hl = 'GitSignsAdd',
            text = '│',
            numhl = 'GitSignsAddNr',
            linehl = 'GitSignsAddLn'
        },
        change = {
            hl = 'GitSignsChange',
            text = '│',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
        },
        delete = {
            hl = 'GitSignsDelete',
            text = '_',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        topdelete = {
            hl = 'GitSignsDelete',
            text = '‾',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        changedelete = {
            hl = 'GitSignsChange',
            text = '~',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
        }
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {interval = 1000, follow_files = true},
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
    yadm = {enable = false}
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

-- Image setup
require('image').setup {}
-- Lsp setup
-- vim.cmd("au BufRead,BufNewFile *.sol setfiletype solidity");
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                     .protocol
                                                                     .make_client_capabilities())
require'lspconfig'.solidity_ls.setup {
    capabilities = capabilities,
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
        {name = 'copilot'}
    }, {{name = 'buffer'}})
}
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true -- false will disable the whole extension
    }
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.diagnostics.solhint,
        require("null-ls").builtins.formatting.lua_format,
        require("null-ls").builtins.formatting.prettier.with({
            filetypes = {"solidity", "javascript"}
        }), require("null-ls").builtins.diagnostics.actionlint
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
require('telescope').load_extension('fzf')
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
