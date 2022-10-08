# nvim-config

nvim 0.8.0 compatible

brew install neovim
brew install solc-select
-- i had to manually install python3.9 for solc-select, unlink, and relink ymmv

copy contents of init.lua into $HOME/.config/nvim/init.lua

I used bun for the js dependencies

curl https://bun.sh/install | bash

bun install -g prettierd
bun install -g solidity-ls
bun install -g solhint

brew install luarocks

luarocks install --server=https://luarocks.org/dev luaformatter

nvim

:PackerInstall

TSInstall solidity
TSInstall lua
...
TSInstall any other languages you need

