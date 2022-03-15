-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use 'prettier/vim-prettier'
  use 'tpope/vim-projectionist'
  use 'Mofiqul/vscode.nvim'
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  use 'tpope/vim-fugitive' -- Git commands in nvim
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use {'numToStr/Comment.nvim'}
  use {'windwp/nvim-autopairs'}
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'voldikss/vim-floaterm'
  end
  )

--jess archer settings                                                                                                                                                   
vim.o.expandtab = true                                                                                                                                                   
vim.o.shiftwidth = 4                                                                                                                                                     
vim.o.tabstop = 4                                                                                                                                                        
vim.o.signcolumn = 'yes:2'                                                                                                                                               
vim.o.relativenumber = true                                                                                                                                              
vim.o.number = true                                                                                                                                                      
vim.o.termguicolors = true                                                                                                                                               
vim.o.undofile = true                                                                                                                                                    
vim.o.title = true                                                                                                                                                       
vim.o.ignorecase = true                                                                                                                                                  
vim.o.smartcase = true                                                                                                                                                   
vim.o.wildmode = 'longest:full,full'                                                                                                                                     
vim.o.wrap = false                                                                                                                                                       
vim.o.list = true                                                                                                                                                        
vim.o.listchars = 'tab:▸ ,trail:·'                                                                                                                                       
vim.o.mouse = 'a'                                                                                                                                                        
vim.o.splitright = true                                                                                                                                                  
vim.o.splitbelow = true                                                                                                                                                  
vim.o.scrolloff = 10                                                                                                                                                      
vim.o.sidescrolloff = 10                                                                                                                                                  
vim.o.clipboard = 'unnamedplus' -- Use Linux system clipboard                                                                                                            
vim.o.confirm = true                                                                                                                                                     
vim.o.backup = true                                                                                                                                                      
vim.o.backupdir = vim.fn.stdpath 'data' .. '/backup//'                                                                                                                   
vim.o.showmode = false                                                                                                                                                   
vim.o.fillchars = 'eob: '                                                                                                                                              
vim.o.hlsearch = false                                                                                                                                                   
vim.o.breakindent = true                                                                                                                                                 
vim.o.updatetime = 150  
-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]
-- prettier on save
vim.cmd [[
autocmd BufWritePre * Prettier
]]
-- Comment
require('Comment').setup()
-- nvim-autopairs
require('nvim-autopairs').setup{}
--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
--Set colorscheme
vim.g.vscode_style = "dark"
-- Enable transparent background.
vim.g.vscode_transparent = 1
-- Enable italic comment
vim.g.vscode_italic_comment = 1
-- Disable nvim-tree background color 
vim.g.vscode_disable_nvimtree_bg = true 
vim.cmd[[colorscheme vscode]]
-- Floatterm
vim.cmd([[
let g:floaterm_keymap_toggle= '<Leader>fo'
]])

-- Lualine 
require('lualine').setup {
  options = {
    theme = 'vscode',
    component_separators = '',
    section_separators = '',
  },
}

-- bufferline
require('bufferline').setup{}

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- vim-projectionist

vim.cmd[[
let g:projectionist_heuristics = {
\ '*':{
\    'src/**/*.sol':{'alternate': 'src/test/**/{}.t.sol'},
\   'src/test/**/*.t.sol':{'alternate': 'src/**/{}.sol'},
\    'src/*.sol':{'alternate': 'src/test/{}.t.sol'},
\   'src/test/*.t.sol':{'alternate':'src/{}.sol'}
\}
\}
]]

-- Lsp setup
vim.cmd("au BufRead,BufNewFile *.sol setfiletype solidity");
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require'lspconfig'.solidity_ls.setup{
    capabilities=capabilities,
    flags = {debounce_text_changes = 150},
    on_attach = function(client)
        -- Keymaps
        -- foundry
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>T', '<cmd>FloatermNew --autoclose=0 make test<CR>', {noremap=true})
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>U', '<cmd>FloatermNew --autoclose=1 make users<CR>', {noremap=true})
        -- unsupported in lsp atm
        vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
        vim.api.nvim_buf_set_keymap(0, 'n', 'gT', '<cmd>lua vim.lsp.buf.type_definition()<CR>', {noremap=true})
        vim.api.nvim_buf_set_keymap(0, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {noremap = true})
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dn', '<cmd>lua vim.diagnostic.goto_next<CR>', {noremap = true})
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dp', '<cmd>lua vim.diagnostic.goto_prev<CR>', {noremap = true})
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dl', '<cmd>Telescope diagnostics<CR>', {noremap=true})
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true})
        -- supported in lsp
        vim.api.nvim_buf_set_keymap(0, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
    end,
}
-- Setup nvim-cmp.
vim.opt.completeopt={"menu","menuone","noselect"}
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      --{ name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })

-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true, -- false will disable the whole extension
  },
}
-- Telescope Setup
--
local action_state = require('telescope.actions.state') -- runtime (Plugin) exists somewhere

require('telescope').setup{
    defaults = {
        prompt_prefix = "$ ",
        mappings = {
            i = {
                ["<c-a>"] = function() print(vim.inspect(action_state.get_selected_entry())) end
            }
        }
    }
}
require('telescope').load_extension('fzf')
vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })

local mappings = {}

mappings.curr_buf = function()
	local opt = require('telescope.themes').get_dropdown({height=10, previewer=false})
	require('telescope.builtin').current_buffer_fuzzy_find(opt)
end
return mappings

