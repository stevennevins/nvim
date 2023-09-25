-- auto create parent directories when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- svelte hack to restart lsp on file save
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("svelte_restart_lsp_on_save", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function()
                if client.name == "svelte" then
                    vim.cmd("LspRestart")
                end
            end,
        })
    end,
})
