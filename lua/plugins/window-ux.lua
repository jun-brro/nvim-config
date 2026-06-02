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
        highlight = { fg = "#7aa2f7" },
        interval = 30,
        no_exec_files = {
          "packer",
          "TelescopePrompt",
          "mason",
          "CompetiTest",
          "neo-tree",
        },
        symbols = { "─", "│", "┌", "┐", "└", "┘" },
      })
    end,
  },
}
