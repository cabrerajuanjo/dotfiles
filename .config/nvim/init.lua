vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'
require('lazy').setup("plugins", {})

-- [[ Configure plugins ]]
-- require 'lazy-plugins'
-- require 'plugins'

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Kickstart plugins ]]
require 'kickstart.plugins.autoformat'


-- [[ Configure Telescope ]]
-- (fuzzy finder)
-- require 'telescope-setup'

-- [[ Configure Treesitter ]]
-- (syntax parser for highlighting)
-- require 'treesitter-setup'

-- [[ Configure LSP ]]
-- (Language Server Protocol)
-- require 'lsp-setup'

-- [[ Configure nvim-cmp ]]
-- (completion)
-- require 'cmp-setup'

-- require 'colorscheme'

--require '_harpoon'


-- Custom http tree-sitter parser
-- vim.cmd("let $PATH = '/Users/juanjosecabrera/.nvm/versions/node/v18.20.3/bin:' . $PATH")
vim.cmd("let $PATH = '/Users/juanjosecabrera/.nvm/versions/node/v22.6.0/bin:' . $PATH")

-- require 'ibl'
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
