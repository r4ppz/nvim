-- I use arrow keys not hjkl cause I am a fucking weirdo

require("configs.mappings.custom")
require("configs.mappings.lsp")
require("configs.mappings.plugins")

local map = require("utils.map")

--------------------------------------------------------------------------
-- Ill put the proper binds here once I learned proper vim key bindings
-- ( Very unlikely )
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move current line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move current line up" })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move current line down (insert mode)" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move current line up (insert mode)" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
