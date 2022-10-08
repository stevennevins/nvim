# nvim-config

nvim 0.8.0 compatible

```
brew install neovim
brew install solc-select
brew install luarocks
```
copy contents of init.lua into $HOME/.config/nvim/init.lua

install bun
```
curl https://bun.sh/install | bash
```

solidity stuff for lsp, diagnostics, and formatting

```
bun install -g solidity-ls
bun install -g prettierd
bun install -g solhint
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
