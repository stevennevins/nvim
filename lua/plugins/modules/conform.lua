return {
    "stevearc/conform.nvim",
    config = function()
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function(args)
                require("conform").format({ bufnr = args.buf })
            end,
        })

        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff" },
                toml = { "taplo" },
                json = { "prettier" },
                markdown = { "prettier" },
            },
        })
    end,
}
