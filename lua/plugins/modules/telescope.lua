local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
end

return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.3",
    event = "VeryLazy",
    dependencies = {
        "nvim-telescope/telescope-fzy-native.nvim",
    },
    config = function()
        local telescope = require("telescope")

        local telescopeConfig = require("telescope.config")
        local builtin = require("telescope.builtin")
        -- Clone the default Telescope configuration
        local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

        -- I don't want to search in the `.git`, 'node_modules', or 'lib' directories.
        table.insert(vimgrep_arguments, "--glob")
        table.insert(vimgrep_arguments, "!.git/*")
        table.insert(vimgrep_arguments, "--glob")
        table.insert(vimgrep_arguments, "!node_modules/*")
        table.insert(vimgrep_arguments, "--glob")
        table.insert(vimgrep_arguments, "!lib/*")
        table.insert(vimgrep_arguments, "--trim")

        telescope.setup({
            defaults = {
                vimgrep_arguments = vimgrep_arguments,
                layout_config = { width = 0.99, preview_cutoff = 1, preview_width = 0.5 },
            },
        })

        map("n", "<leader>d", builtin.diagnostics)
        map("n", "<leader>r", builtin.lsp_references)
        map("n", "<leader>t", builtin.lsp_type_definitions)
        map("n", "<leader>i", builtin.lsp_implementations)
        map("n", "<leader>b", builtin.buffers)
        map("n", "<leader>f", builtin.git_files)
        map("n", "<leader>f", function()
            local ok = pcall(require("telescope.builtin").git_files)
            if not ok then
                require("telescope.builtin").find_files()
            end
        end)
        map("n", "<leader>g", builtin.live_grep)
        map("n", "<leader>p", builtin.resume)
        telescope.load_extension("fzy_native")
    end,
}
