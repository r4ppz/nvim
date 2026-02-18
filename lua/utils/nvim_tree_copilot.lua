local function add_files_to_chat(files)
  local chat = require("CopilotChat")
  if #files == 0 then
    vim.notify("No valid files to add", vim.log.levels.WARN)
    return
  end

  local cwd = vim.fn.getcwd()
  local lines = {}
  for _, file in ipairs(files) do
    local path = vim.startswith(file, cwd) and vim.fn.fnamemodify(file, ":.") or file
    table.insert(lines, "#file:" .. path)
  end

  chat.open()
  vim.schedule(function()
    vim.api.nvim_put(lines, "l", true, true)
    vim.cmd("normal! G")
  end)

  vim.notify(string.format("Added %d file(s) to CopilotChat", #lines), vim.log.levels.INFO)
end

local function collect_files_from_directory(dir)
  local all = vim.fn.globpath(dir, "**/*", false, true)
  local files = {}
  for _, item in ipairs(all) do
    if vim.fn.isdirectory(item) == 0 and vim.fn.filereadable(item) == 1 then
      table.insert(files, item)
    end
  end
  return files
end

local function node_to_files(node)
  if vim.fn.isdirectory(node.absolute_path) == 1 then
    return collect_files_from_directory(node.absolute_path)
  else
    return { node.absolute_path }
  end
end

local function send_to_copilotchat()
  local api = require("nvim-tree.api")
  local marked = api.marks.list()
  local files = {}

  if #marked > 0 then
    for _, node in ipairs(marked) do
      vim.list_extend(files, node_to_files(node))
    end
  else
    local node = api.tree.get_node_under_cursor()
    if node then
      vim.list_extend(files, node_to_files(node))
    end
  end

  add_files_to_chat(files)
  api.marks.clear()
  api.tree.close()
end

local function add_current_file_to_chat()
  local focus_main_window = require("utils.focus_main_window")
  focus_main_window()
  local file = vim.fn.expand("%:p")
  if file == "" or vim.fn.filereadable(file) == 0 then
    vim.notify("No valid file in current buffer", vim.log.levels.WARN)
    return
  end
  add_files_to_chat({ file })
end

local map = require("utils.map")

local function on_attach(bufnr)
  map("n", "<leader>a", send_to_copilotchat, { desc = "Add file(s) to CopilotChat", buffer = bufnr })
end

map("n", "<leader>a", add_current_file_to_chat, { desc = "Add current file to CopilotChat" })

return on_attach
