local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>pl', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
require('telescope').setup {
    defaults = {
        prompt_prefix = "🔍 ",
    },
    pickers = {
        find_files = {
            hidden = true,
            sort_lastused = true,
            no_ignore = true
        },
        live_grep = {
            hidden = true,
            sort_lastused = true,
        },
        git_files = {
            sort_lastused = true,
            hidden = true
        },
        buffers = {
            sort_lastused = true,
            theme = "dropdown",
            previewer = false,
            mappings = {
                i = {
                    ["<C-d>"] = require("telescope.actions").delete_buffer,
                },
                n = {
                    ["<C-d>"] = require("telescope.actions").delete_buffer,
                }
            }
        },
    }
}
