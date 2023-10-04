return {
    "roberte777/keep-it-secret.nvim",
    config = function()
        require("keep-it-secret").setup({
            wildcards = { ".*(.env)$", ".*(.secret)$" },
            enabled = true,
        })
    end,
}
