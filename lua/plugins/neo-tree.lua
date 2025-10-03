return {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf" },
      filesystem = {
        hijack_netrw_behavior = "open_default",  -- 디렉토리 열면 자동으로 탐색기 열기
        follow_current_file = { enabled = true },  -- 현재 열려있는 파일에 따라 움직임
        use_libuv_file_watcher = true,  -- 실시간 변경 감지
      },
      window = {
        -- preview 창 활성화
        mappings = {
          ["P"] = "toggle_preview", -- 수동 토글 단축키 예시
        },
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function(file_path)
            require("neo-tree.command").execute({ action = "close" }) -- preview 이후 자동 닫기 원하면
          end,
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
        },
        git_status = {
          symbols = {
            added     = "✚",
            modified  = "●",
            deleted   = "✖",
            renamed   = "➜",
            untracked = "★",
            ignored   = "◌",
            unstaged  = "✗",
            staged    = "✓",
            conflict  = "",
          },
        },
    },
  }
}
  