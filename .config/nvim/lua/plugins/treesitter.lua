return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local languages = {
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
    }
    local language_set = {}
    for _, language in ipairs(languages) do
      language_set[language] = true
    end

    require('nvim-treesitter').setup {
      install_dir = vim.fn.stdpath('data') .. '/site',
    }

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('juanjo-treesitter', { clear = true }),
      pattern = '*',
      callback = function(event)
        local filetype = vim.bo[event.buf].filetype
        if not language_set[filetype] then
          return
        end

        pcall(vim.treesitter.start, event.buf, filetype)
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
