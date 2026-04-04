-- [[ Configure LSP ]]
-- vim: ts=2 sts=2 sw=2 et
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', opts = {} },
    { 'williamboman/mason-lspconfig.nvim', opts = {} },
    { 'j-hui/fidget.nvim', opts = {} },
    {
      'creativenull/efmls-configs-nvim',
      version = 'v1.x.x',
      dependencies = { 'neovim/nvim-lspconfig' },
    },
    'b0o/schemastore.nvim',
  },
  config = function()
    local format_filter = function(client)
      return client.name ~= 'vtsls'
    end
    local function normalize_root_dir(root_dir, single_file_support)
      if type(root_dir) ~= 'function' then
        return root_dir
      end

      return function(bufnr, on_dir)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local root = root_dir(bufname, bufnr)
        if not root and single_file_support then
          root = bufname ~= '' and vim.fs.dirname(bufname) or vim.uv.cwd()
        end
        if root then
          on_dir(root)
        end
      end
    end

    local function with_default_config(name, config)
      local default_config = require('lspconfig.configs.' .. name).default_config or {}
      default_config = vim.deepcopy(default_config)
      default_config.root_dir = normalize_root_dir(default_config.root_dir, default_config.single_file_support)
      return vim.tbl_deep_extend('force', default_config, config or {})
    end

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('juanjo-lsp-attach', { clear = true }),
      callback = function(event)
        local bufnr = event.buf
        local snacks = require('snacks')
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map('n', '<leader>rn', vim.lsp.buf.rename, 'LSP: [R]e[n]ame')
        map('n', '<leader>ca', vim.lsp.buf.code_action, 'LSP: [C]ode [A]ction')
        map('n', 'gd', function() snacks.picker.lsp_definitions() end, 'LSP: [G]oto [D]efinition')
        map('n', 'gr', function() snacks.picker.lsp_references() end, 'LSP: [G]oto [R]eferences')
        map('n', 'gI', function() snacks.picker.lsp_implementations() end, 'LSP: [G]oto [I]mplementation')
        map('n', '<leader>D', function() snacks.picker.lsp_type_definitions() end, 'LSP: Type [D]efinition')
        map('n', '<leader>ds', function() snacks.picker.lsp_symbols() end, 'LSP: [D]ocument [S]ymbols')
        map('n', '<leader>ws', function() snacks.picker.lsp_workspace_symbols() end, 'LSP: [W]orkspace [S]ymbols')
        map('n', 'gD', vim.lsp.buf.declaration, 'LSP: [G]oto [D]eclaration')
        map('i', '<C-h>', vim.lsp.buf.signature_help, 'LSP: Signature Help')

        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
          vim.lsp.buf.format { filter = format_filter }
        end, { desc = 'Format current buffer with LSP' })
      end,
    })

    require('mason').setup()

    local mason_lspconfig = require('mason-lspconfig')
    local vue_typescript_plugin = vim.fn.expand '$MASON/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin'

    local prettierd = {
      formatCommand = 'prettierd "${INPUT}"',
      formatStdin = true,
      env = {
        string.format('PRETTIERD_DEFAULT_CONFIG=%s', vim.fn.expand('.prettierrc')),
      },
    }

    local shfmt = {
      formatCommand = 'shfmt -ci -s -bn',
      formatStdin = true,
    }

    local shellcheck = {
      lintCommand = 'shellcheck -f gcc -x',
      lintSource = 'shellcheck',
      lintFormats = {
        '%f:%l:%c: %trror: %m',
        '%f:%l:%c: %tarning: %m',
        '%f:%l:%c: %tote: %m',
      },
    }

    local efm_languages = {
      -- typescript = { prettierd },
      -- javascript = { prettierd },
      -- typescriptreact = { prettierd },
      -- markdown = { prettierd },
      -- json = { prettierd },
      -- yaml = { prettierd },
      zsh = { shfmt, shellcheck },
      bash = { shfmt, shellcheck },
      sh = { shfmt, shellcheck },
    }

    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    vim.lsp.config('efm', with_default_config('efm', {
      filetypes = vim.tbl_keys(efm_languages),
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
        codeAction = true,
      },
      settings = {
        rootMarkers = { '.git/', 'manage.py' },
        languages = efm_languages,
      },
    }))

    vim.lsp.config('volar', with_default_config('volar', {
      filetypes = { 'vue' },
      init_options = {
        vue = {
          hybridMode = true,
        },
      },
    }))

    vim.lsp.config('vtsls', with_default_config('vtsls', {
      filetypes = { 'typescript', 'javascript', 'vue', 'typescriptreact', 'typescript.tsx' },
      settings = {
        typescript = {
          updateImportsOnFileMove = 'prompt',
        },
        javascript = {
          updateImportsOnFileMove = 'prompt',
        },
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
          tsserver = {
            globalPlugins = {
              {
                name = '@vue/typescript-plugin',
                location = vue_typescript_plugin,
                languages = { 'vue' },
              },
            },
          },
        },
      },
    }))

    vim.lsp.config('bashls', with_default_config('bashls', {
      filetypes = { 'zsh', 'sh', 'bash' },
    }))

    vim.lsp.config('lua_ls', with_default_config('lua_ls', {
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          diagnostics = { disable = { 'missing-fields' } },
        },
      },
    }))

    vim.lsp.config('biome', with_default_config('biome', {
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'json',
        'jsonc',
      },
      root_markers = { 'biome.json', 'biome.jsonc', 'package.json', '.git' },
    }))

    vim.lsp.config('yamlls', with_default_config('yamlls', {
      settings = {
        yaml = {
          schemaStore = {
            enable = false,
            url = '',
          },
          schemas = require('schemastore').yaml.schemas(),
        },
      },
    }))

    vim.lsp.config('jsonls', with_default_config('jsonls', {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas {
            extra = {
              {
                url = 'https://raw.githubusercontent.com/mistweaverco/kulala.nvim/main/schemas/http-client.env.schema.json',
                name = 'HTTP Client env',
                fileMatch = 'http-client.env.json',
              },
            },
          },
          validate = { enable = true },
        },
      },
    }))

    local servers = {
      'bashls',
      'biome',
      'efm',
      'jsonls',
      'lua_ls',
      'volar',
      'vtsls',
      'yamlls',
    }

    mason_lspconfig.setup {
      ensure_installed = servers,
    }

    vim.lsp.enable(servers)
  end,
}
