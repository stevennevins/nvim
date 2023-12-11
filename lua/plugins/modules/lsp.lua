return {
    {

        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            hint_enable = false,
        },
        config = function(_, opts)
            require("lsp_signature").setup(opts)
        end,
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "folke/neodev.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "onsails/lspkind-nvim",
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            local lsp_signature_help = require("lsp_signature")
            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({ buffer = bufnr })
                lsp_signature_help.on_attach({ buffer = bufnr })
            end)

            lsp_zero.set_server_config({
                on_init = function(client)
                    client.server_capabilities.semanticTokensProvider = nil
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentFormattingRangeProvider = false
                end,
            })
            local lua_opts = lsp_zero.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
            lsp_zero.setup_servers({ "biome", "pyright", "tsserver", "rust_analyzer", "solidity_ls_nomicfoundation" })
            local cmp = require("cmp")
            local cmp_action = lsp_zero.cmp_action()

            cmp.setup({
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    -- `Enter` key to confirm completion
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),

                    -- Ctrl+Space to trigger completion menu
                    ["<C-Space>"] = cmp.mapping.complete(),

                    -- Navigate between snippet placeholder
                    ["<Tab>"] = cmp_action.luasnip_jump_forward(),
                    ["<S-Tab>"] = cmp_action.luasnip_jump_backward(),

                    -- Scroll up and down in the completion documentation
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                }),
            })
        end,
    },
}
