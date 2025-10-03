-- ~/.config/nvim/lua/user/init.lua

-- 수직 분할 (vertical split) : <leader>v
vim.keymap.set("n", "<leader>v", ":vsplit<CR>", { desc = "Vertical Split" })

-- 수평 분할 (horizontal split) : <leader>h
vim.keymap.set("n", "<leader>h", ":split<CR>", { desc = "Horizontal Split" })

-- 버퍼 이동 (buffer navigation) : <Tab>, <S-Tab>
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })

-- 버퍼 닫기 (close buffer) : <leader>c
vim.keymap.set("n", "<leader>c", ":bdelete<CR>", { desc = "Close buffer" })

vim.keymap.set("n", "L", ":bnext<CR>", { desc = "Next buffer (tab-like)" })
vim.keymap.set("n", "H", ":bprevious<CR>", { desc = "Previous buffer (tab-like)" })

vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })             -- Normal 모드
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file (insert)" })  -- Insert 모드