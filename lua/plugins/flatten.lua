return {
  "willothy/flatten.nvim",
  lazy = false,
  priority = 1001,
  opts = function()
    -- Store terminal info: { win = win_id, buf = buf_id, is_float = boolean }
    local saved_terminal = nil

    return {
      window = {
        open = "tab",
        diff = "tab_vsplit",
      },
      block_for = {
        gitcommit = true,
        gitrebase = true,
      },
      hooks = {
        should_block = function(argv)
          if vim.tbl_contains(argv, "-d") then
            return true
          end
          local flatten = require("flatten")
          return flatten.hooks.should_block(argv)
        end,

        pre_open = function()
          saved_terminal = nil
          local cur_win = vim.api.nvim_get_current_win()
          local cur_buf = vim.api.nvim_win_get_buf(cur_win)

          if vim.bo[cur_buf].buftype == "terminal" then
            -- Check if the current terminal window is a floating window
            local is_float = vim.api.nvim_win_get_config(cur_win).relative ~= ""

            saved_terminal = {
              win = cur_win,
              buf = cur_buf,
              is_float = is_float,
            }

            -- Close the floating window so it doesn't block the editor screen
            if is_float then
              vim.api.nvim_win_close(cur_win, true)
            end
          end
        end,

        post_open = function(opts)
          local bufnr = opts.bufnr
          local winnr = opts.winnr
          local ft = opts.filetype
          local is_diff = opts.is_diff

          if winnr and vim.api.nvim_win_is_valid(winnr) then
            vim.api.nvim_set_current_win(winnr)
          end

          -- Clean up temporary git-blob buffers in diff mode
          if is_diff then
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              local buf = vim.api.nvim_win_get_buf(win)
              local name = vim.api.nvim_buf_get_name(buf)
              if name == "" or name:match("git%-blob%-") then
                vim.bo[buf].buftype = "nofile"
                vim.bo[buf].bufhidden = "wipe"
              end
            end
          end

          -- Wipe buffer on close (:wq / :q / :tabclose)
          if ft == "gitcommit" or ft == "gitrebase" then
            vim.bo[bufnr].bufhidden = "wipe"
          end
        end,

        block_end = function()
          vim.schedule(function()
            if saved_terminal then
              if saved_terminal.is_float then
                -- Re-open Lazygit floating window via snacks.nvim
                if _G.Snacks and _G.Snacks.lazygit then
                  Snacks.lazygit()
                end
              else
                -- Focus non-floating terminal window
                if saved_terminal.win and vim.api.nvim_win_is_valid(saved_terminal.win) then
                  vim.api.nvim_set_current_win(saved_terminal.win)
                elseif saved_terminal.buf and vim.api.nvim_buf_is_valid(saved_terminal.buf) then
                  vim.api.nvim_set_current_buf(saved_terminal.buf)
                end
              end
            end
            saved_terminal = nil
          end)
        end,
      },
    }
  end,
}
