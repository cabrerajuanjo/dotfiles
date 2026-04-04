local function picker_git_root()
  local path = vim.api.nvim_buf_get_name(0)
  local start = path ~= '' and vim.fs.dirname(path) or vim.uv.cwd()
  return vim.fs.root(start, '.git') or vim.uv.cwd()
end

local function grep_then_filter(opts)
  opts = opts or {}
  vim.ui.input({ prompt = 'Grep for: ' }, function(search)
    if not search or vim.trim(search) == '' then
      return
    end

    require('snacks').picker.grep(vim.tbl_extend('force', {
      search = vim.trim(search),
      live = false,
    }, opts))
  end)
end

return {
  'folke/snacks.nvim',
  opts = {
    indent = {
      scope = {
        animate = {
          enabled = false,
        },
      },
    },
    picker = {
      win = {
        input = {
          keys = {
            ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
            ['s'] = { 'flash' },
          },
        },
      },
      sources = {
        files = {
          hidden = true,
          ignored = true,
        },
        grep = {
          hidden = true,
        },
      },
    },
  },
  keys = {
    { '<leader><space>', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>sf', function() Snacks.picker.files() end, desc = 'Find Files' },
    { '<C-p>', function() Snacks.picker.files({ hidden = true, ignored = false }) end, desc = 'Find Files' },
    { '<leader>sr', function() Snacks.picker.resume() end, desc = 'Resume Search' },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
    { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
    { '<leader>se', function() require('kulala').set_selected_env() end, desc = 'Select REST Env' },
    { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep' },
    { '<leader>s/', grep_then_filter, desc = 'Grep Then Filter Results' },
    { '<leader>sG', function() Snacks.picker.grep({ cwd = picker_git_root() }) end, desc = 'Grep Git Root' },
    { '<leader>s?', function() grep_then_filter({ cwd = picker_git_root() }) end, desc = 'Grep Git Root Then Filter Results' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Grep Word', mode = { 'n', 'x' } },
  },
}
