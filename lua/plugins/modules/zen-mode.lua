return {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    config = function()
        require("zen-mode").setup({
            window = {
                width = 0.95,
            },
        })
    end,
}
