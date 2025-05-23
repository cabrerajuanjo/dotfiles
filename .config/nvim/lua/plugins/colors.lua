return {
  {
    'kutiny/colors.nvim',
    opts = {
      enable_transparent_bg = false,
      fallback_theme_name = 'moonfly',
      theme_list = { -- or leave nil to use auto list
        'onedark',
        'citruszest',
        'moonfly'
      },
      hide_builtins = false,
      border = 'double', -- single or none
      title = ' My Themes ',
      width = 100,
      height = 20,
      title_pos = 'left', -- left, right or center
      callback_fn = function()
        require('lualine').setup({})
        require('nvim-web-devicons').refresh()
        require('blink.cmp').setup({})
      end
    },
    init = function()
      -- vim.keymap.set('n', '<leader>t', ':ShowThemes<CR>', { silent = true })
    end
  },
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },
  {
    "zootedb0t/citruszest.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000
  },
}
