return {
    -- {
    --     "David-Kunz/gen.nvim",
    --     event = "VeryLazy",
    --     config = function()
    --         require("gen").model = "codellama"
    --     end,
    -- },
    {
        "james1236/backseat.nvim",
        event = "VeryLazy",
        opts = {
            openai_model_id = "gpt-4-1106-preview",
        },
    },
    {
        "CoderCookE/vim-chatgpt",
        event = "VeryLazy",
        config = function()
            vim.g.chat_gpt_model = "gpt-4-1106-preview"
        end,
    },
}
