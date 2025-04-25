return {
  "folke/snacks.nvim",
  opts = {
    indent = {
      -- your indent configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      scope = {
        animate = {
          enabled = false
        }

      }
    },
    ---@class snacks.picker.Config
    ---@field multi? (string|snacks.picker.Config)[]
    ---@field source? string source name and config to use
    ---@field pattern? string|fun(picker:snacks.Picker):string pattern used to filter items by the matcher
    ---@field search? string|fun(picker:snacks.Picker):string search string used by finders
    ---@field cwd? string current working directory
    ---@field live? boolean when true, typing will trigger live searches
    ---@field limit? number when set, the finder will stop after finding this number of items. useful for live searches
    ---@field ui_select? boolean set `vim.ui.select` to a snacks picker
    --- Source definition
    ---@field items? snacks.picker.finder.Item[] items to show instead of using a finder
    ---@field format? string|snacks.picker.format|string format function or preset
    ---@field finder? string|snacks.picker.finder|snacks.picker.finder.multi finder function or preset
    ---@field preview? snacks.picker.preview|string preview function or preset
    ---@field matcher? snacks.picker.matcher.Config|{} matcher config
    ---@field sort? snacks.picker.sort|snacks.picker.sort.Config sort function or config
    ---@field transform? string|snacks.picker.transform transform/filter function
    --- UI
    ---@field win? snacks.picker.win.Config
    ---@field layout? snacks.picker.layout.Config|string|{}|fun(source:string):(snacks.picker.layout.Config|string)
    ---@field icons? snacks.picker.icons
    ---@field prompt? string prompt text / icon
    ---@field title? string defaults to a capitalized source name
    ---@field auto_close? boolean automatically close the picker when focusing another window (defaults to true)
    ---@field show_empty? boolean show the picker even when there are no items
    ---@field focus? "input"|"list" where to focus when the picker is opened (defaults to "input")
    ---@field enter? boolean enter the picker when opening it
    ---@field toggles? table<string, string|false|snacks.picker.toggle>
    --- Preset options
    ---@field previewers? snacks.picker.previewers.Config|{}
    ---@field formatters? snacks.picker.formatters.Config|{}
    ---@field sources? snacks.picker.sources.Config|{}|table<string, snacks.picker.Config|{}>
    ---@field layouts? table<string, snacks.picker.layout.Config>
    --- Actions
    ---@field actions? table<string, snacks.picker.Action.spec> actions used by keymaps
    ---@field confirm? snacks.picker.Action.spec shortcut for confirm action
    ---@field auto_confirm? boolean automatically confirm if there is only one item
    ---@field main? snacks.picker.main.Config main editor window config
    ---@field on_change? fun(picker:snacks.Picker, item?:snacks.picker.Item) called when the cursor changes
    ---@field on_show? fun(picker:snacks.Picker) called when the picker is shown
    ---@field on_close? fun(picker:snacks.Picker) called when the picker is closed
    ---@field jump? snacks.picker.jump.Config|{}
    --- Other
    ---@field config? fun(opts:snacks.picker.Config):snacks.picker.Config? custom config function
    ---@field db? snacks.picker.db.Config|{}
    ---@field debug? snacks.picker.debug|{}
    picker = {
      win = {
        input = {
          keys = {
            ["<a-s>"] = { "flash", mode = { "n", "i" } },
            ["s"] = { "flash" },
          },
        },
      },
      sources = {
        files = {
          hidden = true,
          ignored = true,
        },
        grep = { hidden = true },
      },
      -- actions = {
      --       label = { after = { 0, 0 } },
      --       search = {
      --         mode = "search",
      --         exclude = {
      --           function(win)
      --             return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
      --           end,
      --         },
      --       },
      --       action = function(match)
      --         local idx = picker.list:row2idx(match.pos[1])
      --         picker.list:_move(idx, true, true)
      --       end,
      --     })
      --   end,
      -- },
    },
  },
  keys = {
    -- Top Pickers & Explorer
    -- { "<leader><space>", function() Snacks.picker.smart() end,        desc = "Smart Find Files" },
    { "<leader><space>", function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
    -- { "<leader>/",  function() Snacks.picker.grep() end,      desc = "Grep" },
    { "<leader>sf",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
    { "<C-p>",           function() Snacks.picker.files({ hidden = true, ignored = false }) end, desc = "Find Files" },
    { "<leader>sr",      function() Snacks.picker.resume() end,                                  desc = "Resume search" },
    -- { "<C-p>",           function() Snacks.picker.git_files() end,                             desc = "Find Git Files" },
    -- { "<leader>fp", function() Snacks.picker.projects() end,  desc = "Projects" },
    -- { "<leader>fr", function() Snacks.picker.recent() end,    desc = "Recent" },
    -- git
    -- { "<leader>gb",      function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    -- { "<leader>gl",      function() Snacks.picker.git_log() end,      desc = "Git Log" },
    -- { "<leader>gL",      function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    -- { "<leader>gs",      function() Snacks.picker.git_status() end,   desc = "Git Status" },
    -- { "<leader>gS",      function() Snacks.picker.git_stash() end,    desc = "Git Stash" },
    { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
    -- { "<leader>gf",      function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Grep
    -- { "<leader>sb",      function() Snacks.picker.lines() end,        desc = "Buffer Lines" },
    -- { "<leader>sB",      function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
    -- { "<leader>sw",      function() Snacks.picker.grep_word() end,    desc = "Visual selection or word", mode = { "n", "x" } },
  },
}
