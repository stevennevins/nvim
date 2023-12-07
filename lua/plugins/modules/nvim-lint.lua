return {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                require("lint").try_lint()
            end,
        })
        require("lint").linters_by_ft = {
            markdown = { "vale", "typos", "write-good" },
            solidity = { "solhint", "typos", "write-good" },
            python = { "ruff", "typos", "write-good" },
            javascript = { "biomejs", "typos" },
        }
    end,
}
