-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  end
  )

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Lsp setup
vim.cmd("au BufRead,BufNewFile *.sol setfiletype solidity");
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require'lspconfig'.solidity_ls.setup{
	capabilities=capabilities,
	on_attach = function(client)
		-- Keymaps
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
		-- Use LSP as the handler for omnifunc.
      		--    See `:help omnifunc` and `:help ins-completion` for more information.
      		vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      		-- Use LSP as the handler for formatexpr.
      		--    See `:help formatexpr` for more information.
      		vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
      		-- For plugins with an `on_attach` callback, call them here. For example:
      		-- require('completion').on_attach()
	end,
}
-- Setup nvim-cmp.
vim.opt.completeopt={"menu","menuone","noselect"}
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
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
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })

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

local mappings = {}

mappings.curr_buf = function()
	local opt = require('telescope.themes').get_dropdown({height=10, previewer=false})
	require('telescope.builtin').current_buffer_fuzzy_find(opt)
end
return mappings

