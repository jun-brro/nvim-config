-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- disable relative line numbers to keep line numbers fixed
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- Telescope file search (excludes .out, .err)
        ["<Leader>ff"] = {
          function()
            require("telescope.builtin").find_files({
              file_ignore_patterns = {
                "__pycache__/", "%.pyc$", "node_modules/", "%.git/", "%.DS_Store",
                "%.out$", "%.err$",
              },
            })
          end,
          desc = "Find files",
        },
        -- Telescope file search (includes .out, .err)
        ["<Leader>fa"] = {
          function()
            require("telescope.builtin").find_files({
              file_ignore_patterns = {
                "__pycache__/", "%.pyc$", "node_modules/", "%.git/", "%.DS_Store",
              },
            })
          end,
          desc = "Find all files (incl. .out/.err)",
        },

        -- Open current file with system app
        ["<Leader>o"] = {
          function()
            local file = vim.fn.expand("%:p")
            if file ~= "" then
              vim.fn.system({ "xdg-open", file })
              vim.notify("Opened: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
            end
          end,
          desc = "Open with system app",
        },

        -- Find media files and open with system app
        ["<Leader>fm"] = {
          function()
            require("telescope.builtin").find_files({
              prompt_title = "Media Files",
              find_command = {
                "find", ".", "-type", "f",
                "(", "-name", "*.png", "-o", "-name", "*.jpg", "-o", "-name", "*.jpeg",
                "-o", "-name", "*.gif", "-o", "-name", "*.mp4", "-o", "-name", "*.webm",
                "-o", "-name", "*.mp3", "-o", "-name", "*.wav", ")",
                "-not", "-path", "*/.git/*",
              },
              attach_mappings = function(_, map)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                map("i", "<CR>", function(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  vim.fn.system({ "xdg-open", entry.path })
                  vim.notify("Opened: " .. entry.value, vim.log.levels.INFO)
                end)
                map("n", "<CR>", function(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  vim.fn.system({ "xdg-open", entry.path })
                  vim.notify("Opened: " .. entry.value, vim.log.levels.INFO)
                end)
                return true
              end,
            })
          end,
          desc = "Find media files",
        },

        -- Numbered toggleterms (:<N>ToggleTerm)
        ["<Leader>t1"] = { "<Cmd>1ToggleTerm<CR>", desc = "Toggle terminal 1" },
        ["<Leader>t2"] = { "<Cmd>2ToggleTerm<CR>", desc = "Toggle terminal 2" },
        ["<Leader>t3"] = { "<Cmd>3ToggleTerm<CR>", desc = "Toggle terminal 3" },
        ["<Leader>t4"] = { "<Cmd>4ToggleTerm<CR>", desc = "Toggle terminal 4" },
        ["<Leader>ts"] = { "<Cmd>TermSelect<CR>", desc = "Select terminal" },

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
