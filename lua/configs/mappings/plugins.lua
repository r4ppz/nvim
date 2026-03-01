local map = require("utils.map")

-- Plugins? (other keybinds are in the plugins lua files)

---------------------------------------------------------------------
-- TERMINAL MANAGEMENT
local focus_main_window = require("utils.focus_main_window")

-- Keymaps
map({ "n", "t" }, "<A-w>", function()
  focus_main_window()
  require("nvchad.term").toggle({
    pos = "float",
    id = "float_term",
  })
end, { desc = "Toggle Floating Terminal" })

map({ "n", "t" }, "<M-S-d>", function()
  focus_main_window()
  local term = require("nvchad.term")
  term.toggle({
    pos = "float",
    id = "lazydocker_float",
    float_opts = {
      row = 0.05,
      col = 0.05,
      width = 0.9,
      height = 0.8,
      border = "single",
    },
    cmd = "lazydocker",
  })

  -- map q to close/toggle the terminal (not LazyDocker)
  local buf = vim.api.nvim_get_current_buf()
  map("t", "q", function()
    term.toggle({ id = "lazydocker_float" })
  end, { buffer = buf })
end, { desc = "Toggle LazyDocker" })

map({ "n", "t" }, "<A-s>", function()
  focus_main_window()
  require("nvchad.term").toggle({
    pos = "sp",
    id = "horizontal_term",
    size = 0.6,
  })
end, { desc = "Toggle Horizontal Terminal" })

map({ "n", "t" }, "<A-v>", function()
  focus_main_window()
  require("nvchad.term").toggle({
    pos = "vsp",
    id = "vertical_term",
    size = 0.5,
  })
end, { desc = "Toggle Vertical Terminal" })

map("n", "<A-t>", function()
  vim.cmd("enew")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "New Terminal Buffer" })

---------------------------------------------------------------------
-- BUFFERS MANAGEMENT
local safe_buf_action = require("utils.safe_buf_action")

map("n", "<leader>n", "<cmd>enew<CR>", { desc = "Buffer new" })

-- change buffer (Protected)
map(
  { "n" },
  "<M-Right>",
  safe_buf_action(function()
    require("nvchad.tabufline").next()
  end),
  { desc = "Buffer goto next" }
)
map(
  { "n" },
  "<M-Left>",
  safe_buf_action(function()
    require("nvchad.tabufline").prev()
  end),
  { desc = "Buffer goto prev" }
)

-- move buffer (Protected)
map(
  { "n" },
  "<C-M-Right>",
  safe_buf_action(function()
    require("nvchad.tabufline").move_buf(1)
  end),
  { desc = "move buffer to the right" }
)
map(
  { "n" },
  "<C-M-Left>",
  safe_buf_action(function()
    require("nvchad.tabufline").move_buf(-1)
  end),
  { desc = "move buffer to the left" }
)

-- close buffer
map("n", "<leader>q", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer close" })
map("n", "<M-q>", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer close" })
map("n", "<S-M-Q>", function()
  require("nvchad.tabufline").closeAllBufs(false)
end, { desc = "Close all buffers except current" })

---------------------------------------------------------------------

-- NVCHAD
map("n", "<leader>vc", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })
map("n", "<leader>vt", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

-- UI
map("n", "<leader>um", "<cmd>Mason<CR>", { desc = "Mason UI" })
map("n", "<leader>ul", "<cmd>Lazy<CR>", { desc = "Lazy UI" })

-- Tabs
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tX", "<cmd>tabonly<CR>", { desc = "Close all other tabs" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<Tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<S-Tab>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>t<Right>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>t<Left>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
