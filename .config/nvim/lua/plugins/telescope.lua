return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },

  opts = function()
    -- require("telescope").load_extension("rest")
    -- require("telescope").extensions.rest.select_env()
    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require("telescope").load_extension, 'git_worktree')

    -- Telescope live_grep in git root
    -- Function to find the git root directory based on the current buffer's path
    local function find_git_root()
      -- Use the current buffer's path as the starting point for the git search
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_dir
      local cwd = vim.fn.getcwd()
      -- If the buffer is not associated with a file, return nil
      if current_file == '' then
        current_dir = cwd
      else
        -- Extract the directory from the current file's path
        current_dir = vim.fn.fnamemodify(current_file, ':h')
      end

      -- Find the Git root directory from the current file's path
      local git_root = vim.fn.systemlist('git -C ' ..
        vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
      if vim.v.shell_error ~= 0 then
        print 'Not a git repository. Searching on current working directory'
        return cwd
      end
      return git_root
    end

    -- Custom live_grep function to search in git root
    local function live_grep_git_root()
      local git_root = find_git_root()
      if git_root then
        require('telescope.builtin').live_grep {
          search_dirs = { git_root },
        }
      end
    end

    vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

    -- See `:help telescope.builtin`
    -- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
    --   { desc = '[?] Find recently opened files' })
    -- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,
      -- { desc = '[ ] Find existing buffers' })
    -- vim.keymap.set('n', '<leader>/', function()
    --   -- You can pass additional configuration to telescope to change theme, layout, etc.
    --   require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    --     winblend = 10,
    --     previewer = false,
    --   })
    -- end, { desc = '[/] Fuzzily search in current buffer' })

    local function telescope_live_grep_open_files()
      require('telescope.builtin').live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end
    -- vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
    -- vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
    -- vim.keymap.set('n', '<C-p>', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
    -- vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
    -- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
    -- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
    -- vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
    -- vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
    -- vim.keymap.set('n', '<leader>st', require('telescope').extensions.git_worktree.git_worktrees,
    --   { desc = '[S]earch Worktrees' })
    -- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
    -- vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
    -- vim.keymap.set('n', '<leader>se', require('telescope').extensions.rest.select_env,
    -- { desc = '[S]earch RestNvim [E]nvironment' })
    local actions = require "telescope.actions"

    return {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--pcre2",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--hidden",
          "--smart-case",
        },
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ["<C-s>"] = actions.send_selected_to_qflist + actions.open_qflist
          },
          n = {
            ["<C-s>"] = actions.send_selected_to_qflist + actions.open_qflist
          }
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          theme = "dropdown",
          sort_lastused = true,
          no_ignore = true
        },
        live_grep = {
          hidden = true,
          theme = "dropdown",
          sort_lastused = true,
        },
        git_files = {
          sort_lastused = true,
          theme = "dropdown",
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
              ["<leader>w"] = function()
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                  local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
                  if buftype == '' then
                    vim.api.nvim_buf_call(bufnr, function()
                      vim.cmd('w')
                    end)
                  end
                end
              end,
            }
          }
        }
      }
    }
  end,
}
