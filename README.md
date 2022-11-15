# nvim-config

nvim 0.8.0 compatible

```
brew install neovim
brew install solc-select
brew install luarocks
brew install fsouza/prettierd/prettierd
brew install ripgrep
brew install fd
```
copy contents of init.lua into $HOME/.config/nvim/init.lua

solidity stuff for lsp

```
npm install -g solidity-ls
npm install -g solhint
```

lua formatter
```
luarocks install --server=https://luarocks.org/dev luaformatter
```

open neovim
```
nvim
```

install plugins
```
:PackerInstall
```

install language specific syntax highlighting
```
:TSInstall solidity
:TSInstall lua
...
:TSInstall any other languages you need
```
