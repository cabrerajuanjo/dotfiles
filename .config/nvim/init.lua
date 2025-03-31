vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'
require('lazy').setup("plugins", {})

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Kickstart plugins ]]
require 'kickstart.plugins.autoformat'

vim.cmd("let $PATH = '/Users/juanjosecabrera/.nvm/versions/node/v22.6.0/bin:' . $PATH")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
