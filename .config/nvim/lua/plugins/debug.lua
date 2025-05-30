return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- vim.keymap.set("n", "<Leader>db", function()
    --   dap.toggle_breakpoint()
    -- end)
    -- vim.keymap.set("n", "<Leader>dc", function()
    --   dap.continue()
    -- end)

    local debugger_path = vim.fn.stdpath("data") .. "/vscode-js-debug"
    local debugger_tarball = debugger_path .. "/js-debug-dap.tar.gz"
    local debugger_location = debugger_path .. "/src/dapDebugServer.js"

    -- Ensure the debugger directory exists
    vim.fn.system({ "mkdir", "-p", debugger_path })

    -- Automatically download and set up vscode-js-debug if not already done
    if not vim.loop.fs_stat(debugger_location) then
      print("Downloading vscode-js-debug latest release...")
      local release_url =
      "https://github.com/microsoft/vscode-js-debug/releases/download/v1.97.1/js-debug-dap-v1.97.1.tar.gz"

      -- Download the tarball
      vim.fn.system({ "curl", "-L", release_url, "-o", debugger_tarball })

      -- Extract the tarball
      print("Extracting vscode-js-debug...")
      local extract_cmd = "tar -xzf " .. debugger_tarball .. " -C " .. debugger_path .. " --strip-components=1"
      local result = vim.fn.system(extract_cmd)

      -- Check for errors during extraction
      if vim.v.shell_error ~= 0 then
        print("Error extracting vscode-js-debug: " .. result)
        return
      end

      -- Cleanup the tarball after successful extraction
      print("Cleaning up...")
      os.remove(debugger_tarball)

      print("vscode-js-debug setup complete.")
    end

    dap.adapters["pwa-node"] = {
      type = "server",
      command = "node",
      port = "${port}",
      host = "localhost",
      executable = {
        command = "node",
        args = { debugger_location, "${port}" },
      },
    }

    dap.configurations.typescript = {
      {
        -- dap-nvim specific
        type = "pwa-node",
        request = "launch",
        name = "Nvim Dap typescript",
        -- language specific
        program = "${workspaceFolder}/node_modules/@nestjs/cli/bin/nest.js",
        args = { "start", "--builder", "swc", "--watch" },
        cwd = "${workspaceFolder}",
        envFile = "${workspaceFolder}/.env",
        autoAttachChildProcesses = true,
        sourceMaps = true,
        outFiles = { "${workspaceFolder}/dist/**/*.js" },
        runtimeArgs = { "--nolazy" },
        console = "integratedTerminal",
        outputCapture = "std"
      }
    }

    vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
    vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

    vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
    vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
    vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
    vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
    vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
    -- vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
    -- vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
    vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
    vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
      require('dap.ui.widgets').hover()
    end)
    vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
      require('dap.ui.widgets').preview()
    end)
    vim.keymap.set('n', '<Leader>df', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<Leader>ds', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.scopes)
    end)
  end,
}
