-- Treesitter on the `main` branch (required for Neovim 0.12+).
--
-- AstroNvim core pins nvim-treesitter to the archived `master` branch, which is
-- incompatible with Neovim 0.12 (removed/changed treesitter node APIs -> the
-- "attempt to call method 'range'/'parent' (a nil value)" errors).
--
-- The `main` branch has NO built-in modules (highlight/indent/incremental_selection/
-- textobjects), so we wire those up ourselves using Neovim's native treesitter API.

local ensure_installed = {
  "bash",
  "c",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "vim",
  "vimdoc",
  -- add more parsers here
}

---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- override AstroNvim's `branch = "master"`
    build = ":TSUpdate",
    lazy = false,
    -- Replace AstroNvim's master-only config entirely.
    config = function()
      require("nvim-treesitter").setup {}

      -- Install/keep parsers up to date (async; no-op when already present).
      pcall(function() require("nvim-treesitter").install(ensure_installed) end)

      -- main branch dropped the highlight/indent modules: enable them via the
      -- native API on every buffer that has a parser available.
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Enable treesitter highlight + indent (main branch)",
        callback = function(ev)
          local ft = vim.bo[ev.buf].filetype
          if ft == "" then return end
          local lang = vim.treesitter.language.get_lang(ft) or ft
          if not pcall(vim.treesitter.start, ev.buf, lang) then return end
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Textobjects (already pinned to `main` by AstroNvim) — restore the keymaps
  -- AstroNvim used to configure via the old module system.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      local select = require "nvim-treesitter-textobjects.select"
      local move = require "nvim-treesitter-textobjects.move"
      local swap = require "nvim-treesitter-textobjects.swap"
      local map = vim.keymap.set

      -- select: a*/i*
      local selects = {
        ["ak"] = "@block.outer",
        ["ik"] = "@block.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["a?"] = "@conditional.outer",
        ["i?"] = "@conditional.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ao"] = "@loop.outer",
        ["io"] = "@loop.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      }
      for lhs, query in pairs(selects) do
        map({ "x", "o" }, lhs, function() select.select_textobject(query, "textobjects") end, { desc = "textobject " .. query })
      end

      -- move: ]/[ next/previous start/end
      local moves = {
        { lhs = "]k", fn = "goto_next_start", q = "@block.outer", d = "Next block start" },
        { lhs = "]f", fn = "goto_next_start", q = "@function.outer", d = "Next function start" },
        { lhs = "]a", fn = "goto_next_start", q = "@parameter.inner", d = "Next argument start" },
        { lhs = "]K", fn = "goto_next_end", q = "@block.outer", d = "Next block end" },
        { lhs = "]F", fn = "goto_next_end", q = "@function.outer", d = "Next function end" },
        { lhs = "]A", fn = "goto_next_end", q = "@parameter.inner", d = "Next argument end" },
        { lhs = "[k", fn = "goto_previous_start", q = "@block.outer", d = "Previous block start" },
        { lhs = "[f", fn = "goto_previous_start", q = "@function.outer", d = "Previous function start" },
        { lhs = "[a", fn = "goto_previous_start", q = "@parameter.inner", d = "Previous argument start" },
        { lhs = "[K", fn = "goto_previous_end", q = "@block.outer", d = "Previous block end" },
        { lhs = "[F", fn = "goto_previous_end", q = "@function.outer", d = "Previous function end" },
        { lhs = "[A", fn = "goto_previous_end", q = "@parameter.inner", d = "Previous argument end" },
      }
      for _, m in ipairs(moves) do
        map({ "n", "x", "o" }, m.lhs, function() move[m.fn](m.q, "textobjects") end, { desc = m.d })
      end

      -- swap: >/< next/previous
      local swaps = {
        { lhs = ">K", fn = "swap_next", q = "@block.outer", d = "Swap next block" },
        { lhs = ">F", fn = "swap_next", q = "@function.outer", d = "Swap next function" },
        { lhs = ">A", fn = "swap_next", q = "@parameter.inner", d = "Swap next argument" },
        { lhs = "<K", fn = "swap_previous", q = "@block.outer", d = "Swap previous block" },
        { lhs = "<F", fn = "swap_previous", q = "@function.outer", d = "Swap previous function" },
        { lhs = "<A", fn = "swap_previous", q = "@parameter.inner", d = "Swap previous argument" },
      }
      for _, s in ipairs(swaps) do
        map("n", s.lhs, function() swap[s.fn](s.q) end, { desc = s.d })
      end
    end,
  },
}
