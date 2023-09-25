-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

require("config.options")
require("config.keymaps")
require("config.augroup")

require("plugins")
