local excluded = { "copilot-chat", "NvimTree", "Outline" }

-- Wraps a buffer action to safely execute it only if the
-- current window is not a floating window and the buffer's
-- filetype is not in the excluded list.
local function safe_buf_action(action)
  return function()
    local win_cfg = vim.api.nvim_win_get_config(0)
    if win_cfg.relative ~= "" then
      return
    end

    local ft = vim.bo.filetype

    for _, v in ipairs(excluded) do
      if ft == v then
        return
      end
    end

    pcall(action)
  end
end

return safe_buf_action
