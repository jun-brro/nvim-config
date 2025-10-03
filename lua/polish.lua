-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Python 전용 줄 번호 설정

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      vim.opt.number = true
      vim.opt.relativenumber = false
    end,
  })
  
  -- Snacks 설정 반환
  return {
    "AstroNvim/astrocore",
    opts = {
      features = {
        ["snacks.quickfile"] = true,
        ["snacks.words"] = true,
        ["snacks.scroll"] = true,
        ["snacks.statuscolumn"] = true,
      }
    }
  }
  