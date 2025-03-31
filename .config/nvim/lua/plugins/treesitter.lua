return {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',

    opts = function()
        require('nvim-treesitter.configs').setup {
            -- Add languages to be installed here that you want installed for treesitter
            ensure_installed = {
                'c',
                'cpp',
                'go',
                'lua',
                'python',
                'dockerfile',
                'rust',
                'tsx',
                'javascript',
                'typescript',
                'vimdoc',
                'vim',
                'bash',
                'markdown',
                'vue',
                'css',
                'http',
                'scss',
                'prisma',
                'mermaid',
                'terraform',
            },

            -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
            auto_install = true,

            ignore_install = {},
            sync_install = false,
            modules = {},
            highlight = { enable = true },
            indent = { enable = true },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                      ['<leader>sa'] = '@parameter.inner',
                    },
                    swap_previous = {
                        ['<leader>sA'] = '@parameter.inner',
                    },
                },
            },
        }
    end
}
