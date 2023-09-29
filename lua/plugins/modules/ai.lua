return {
    {
        "james1236/backseat.nvim",
        opts = {
            openai_model_id = "gpt-3.5-turbo",
        },
    },
    {
        "CoderCookE/vim-chatgpt",
        config = function()
            vim.g.chat_gpt_mod = "gpt-4-32k"
        end,
    },
}
