-- [[ Configure LSP ]]
-- vim: ts=2 sts=2 sw=2 et
return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim',           opts = {} },
    { 'williamboman/mason-lspconfig.nvim', opts = {} },
    { 'j-hui/fidget.nvim',                 opts = {} },
    {
      'creativenull/efmls-configs-nvim',
      version = 'v1.x.x', -- version is optional, but recommended
      dependencies = { 'neovim/nvim-lspconfig' },
    },
    -- Additional lua configuration, makes nvim stuff amazing!
    { 'folke/neodev.nvim', opts = {} },
    'b0o/schemastore.nvim'
  },
  config = function()
    local on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end)

      nmap('gD', vim.lsp.buf.type_definition, '[G]oto [D]eclaration')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    end

    -- mason-lspconfig requires that these setup functions are called in this order
    -- before setting up the servers.
    require('mason').setup()
    require('mason-lspconfig').setup()
    --
    -- Vue typescript plugin
    local vue_typescript_plugin = require('mason-registry')
        .get_package('vue-language-server')
        :get_install_path()
        .. '/node_modules/@vue/language-server'
        .. '/node_modules/@vue/typescript-plugin'


    -- EFM Language Server
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
      typescript = { prettierd },
      javascript = { prettierd },
      typescriptreact = { prettierd },
      markdown = { prettierd },
      json = { prettierd },
      yaml = { prettierd },
      zsh = { shfmt, shellcheck },
      bash = { shfmt, shellcheck },
      sh = { shfmt, shellcheck },
    }

    local servers = {
      efm = {
        filetypes = vim.tbl_keys(efm_languages),
        settings = {
          rootMarkers = { '.git/', 'manage.py' },
          languages = efm_languages,
        },
        init_options = {
          documentFormatting = true,
          documentRangeFormatting = true,
          codeAction = true,
        },
      },

      volar = {
        filetypes = { 'vue' },
        init_options = {
          vue = {
            hybridMode = true
          }
        },
      },

      vtsls = {
        filetypes = { 'typescript', 'javascript', 'vue', "typescriptreact", "typescript.tsx" },
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        updateImportsOnFileMove = true,
        settings = {
          typescript = {
            updateImportsOnFileMove = "prompt",
          },
          javascript = {
            updateImportsOnFileMove = "prompt",
          },
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_typescript_plugin,
                  languages = { 'vue' }
                },
              },
            },
          },
        },
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },

      bashls = {
        filetypes = { 'zsh', 'sh', 'bash' },
      },

      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          diagnostics = { disable = { 'missing-fields' } },
        },
      },

      eslint = {
        filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
      },

      yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like ignore.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      },

      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas {
              extra = {
                url = "https://raw.githubusercontent.com/mistweaverco/kulala.nvim/main/schemas/http-client.env.schema.json",
                name = "HTTP Client env",
                fileMatch = "http-client.env.json"
              }
            },
            validate = { enable = true },
          },
        },
      },
    }

    -- Setup neovim lua configuration
    require('neodev').setup()

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('blink-cmp').get_lsp_capabilities(capabilities)

    -- Ensure the servers above are installed
    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    mason_lspconfig.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          init_options = (servers[server_name] or {}).init_options,
          filetypes = (servers[server_name] or {}).filetypes,
          settings = (servers[server_name] or {}).settings,
        }
      end,
    }
  end
}
