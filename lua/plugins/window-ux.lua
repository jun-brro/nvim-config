---@type LazySpec
return {
  -- Session auto-save / auto-restore (split layout 복원)
  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
      auto_session_use_git_branch = false,
    },
  },

  -- Active window border highlight
  {
    "nvim-zh/colorful-winsep.nvim",
    event = { "WinNew" },
    config = function()
      require("colorful-winsep").setup({
        -- v2 API: highlight is nil|string|function (table no longer supported)
        highlight = "#7aa2f7",
        border = { "─", "│", "┌", "┐", "└", "┘" },
        excluded_ft = {
          "packer",
          "TelescopePrompt",
          "mason",
          "CompetiTest",
          "neo-tree",
        },
      })
    end,
  },
}
