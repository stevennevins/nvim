return {
    {
        "james1236/backseat.nvim",
        event = "VeryLazy",
        opts = {
            openai_model_id = "gpt-3.5-turbo-16k",
        },
    },
    {
        "CoderCookE/vim-chatgpt",
        event = "VeryLazy",
        config = function()
            vim.g.chat_gpt_mod = "gpt-4-32k"
        end,
    },
}
